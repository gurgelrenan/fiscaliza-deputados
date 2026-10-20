import test from "node:test"
import assert from "node:assert/strict"
import { readFileSync } from "node:fs"
import { runInNewContext } from "node:vm"

const source = readFileSync(new URL("../../app/javascript/analytics.js", import.meta.url), "utf8")

function browser({ enabled = true } = {}) {
  const events = []
  const listeners = new Map()
  const state = { page: "deputies_list", properties: {}, preview: false }
  const document = {
    documentElement: { hasAttribute: () => state.preview },
    querySelector: () => ({ dataset: {
      analyticsPage: state.page,
      analyticsProperties: JSON.stringify(state.properties)
    } }),
    addEventListener: (name, callback) => {
      listeners.set(name, [...(listeners.get(name) || []), callback])
    }
  }
  const window = enabled ? { posthog: { capture: (event, properties) => events.push({ event, properties }) } } : {}
  runInNewContext(source, { document, window })
  return {
    events, state,
    dispatch: (name, event = {}) => listeners.get(name)?.forEach(callback => callback({ type: name, ...event }))
  }
}

test("tracks initial, Turbo and restored pages once with the current deputy context", () => {
  const { events, state, dispatch } = browser()
  dispatch("turbo:load")
  state.page = "deputy_expenses"
  state.properties = { deputy_id: 123, deputy_name: "Ana", month: "2022-01" }
  state.preview = true
  dispatch("turbo:load")
  assert.equal(events.length, 2)
  state.preview = false
  dispatch("turbo:render")
  dispatch("turbo:load")
  assert.deepEqual(events.map(item => item.event), [
    "$pageview", "deputies_list_viewed", "$pageview", "deputy_expenses_viewed", "monthly_expenses_viewed"
  ])
  assert.equal(events.at(-1).properties.deputy_id, 123)
  state.page = "deputies_list"
  state.properties = {}
  dispatch("turbo:load")
  assert.equal(events.filter(item => item.event === "$pageview").length, 3)
  assert.equal(events.at(-1).properties.deputy_id, undefined)
})

test("captures receipt clicks, including middle clicks, without cancelling navigation", () => {
  const { events, dispatch } = browser()
  const link = { dataset: { analyticsFeature: "open_receipt", analyticsProperties: '{"expense_id":42}' } }
  const event = { target: { closest: () => link } }
  dispatch("click", event)
  dispatch("auxclick", { ...event, button: 1 })
  dispatch("auxclick", { ...event, button: 2 })
  assert.equal(events.length, 2)
  assert.equal(events[0].event, "feature_used")
  assert.equal(events[0].properties.feature, "open_receipt")
  assert.equal(events[0].properties.expense_id, 42)
})

test("filter submissions use the newly selected value instead of the old page filter", () => {
  const { events, state, dispatch } = browser()
  state.properties = { expense_type_id: 1 }
  const select = { value: "2", selectedOptions: [{ textContent: "Combustíveis" }] }
  const form = { dataset: { analyticsFeature: "filter_expenses" }, querySelector: () => select }
  dispatch("submit", { target: { closest: () => form } })
  assert.equal(events[0].properties.expense_type_id, "2")
  select.value = ""
  dispatch("submit", { target: { closest: () => form } })
  assert.equal(events[1].properties.expense_type_id, null)
})

test("unconfigured analytics and unrelated interactions leave navigation working", () => {
  const { events, dispatch } = browser({ enabled: false })
  dispatch("turbo:load")
  dispatch("click", { target: { closest: () => null } })
  dispatch("submit", { target: { closest: () => null } })
  assert.equal(events.length, 0)
})

test("search tracks usage without capturing the query or empty submissions", () => {
  const { events, dispatch } = browser()
  const input = { value: "José Guimarães" }
  const form = { dataset: { analyticsFeature: "search_deputies" }, querySelector: () => input }
  dispatch("submit", { target: { closest: () => form } })
  assert.equal(events[0].properties.feature, "search_deputies")
  assert.equal(JSON.stringify(events).includes(input.value), false)
  input.value = "   "
  dispatch("submit", { target: { closest: () => form } })
  assert.equal(events.length, 1)
})

test("PostHog sanitizes search text in current, referrer and initial URLs", () => {
  const partial = readFileSync(new URL("../../app/views/layouts/_posthog.html.erb", import.meta.url), "utf8")
  const callback = partial.match(/before_send: (function\(event\) \{[\s\S]*?return event;\s*\})/)[1]
  const sanitize = runInNewContext(`(${callback})`, { URL })
  const event = { properties: {
    $current_url: "https://example.com/deputies?q=Jose&utm_source=test#parlamentares",
    $referrer: "$direct",
    $set: { $initial_current_url: "https://example.com/?q=Jose" },
    $set_once: { $initial_referrer: "https://example.com/?q=Jose" }
  } }
  sanitize(event)
  assert.equal(event.properties.$current_url, "https://example.com/deputies?utm_source=test#parlamentares")
  assert.equal(event.properties.$referrer, "$direct")
  assert.equal(JSON.stringify(event).includes("Jose"), false)
})
