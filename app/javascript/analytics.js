function propertiesFor(element) {
  return JSON.parse(element?.dataset.analyticsProperties || "{}")
}

function pageContext() {
  const page = document.querySelector("[data-analytics-page]")
  return { page: page?.dataset.analyticsPage, ...propertiesFor(page) }
}

function capture(event, properties = {}) {
  window.posthog?.capture(event, { ...pageContext(), ...properties })
}

// turbo:load fires for the initial visit, completed navigations and back/forward.
// Avoid turbo:render: it also fires for cached previews, duplicating page views.
document.addEventListener("turbo:load", () => {
  if (document.documentElement.hasAttribute("data-turbo-preview")) return

  const context = pageContext()
  if (!context.page) return

  capture("$pageview")
  if (context.page === "deputies_list") capture("deputies_list_viewed")
  if (context.page === "deputy_expenses") {
    capture("deputy_expenses_viewed")
    if (context.month) capture("monthly_expenses_viewed")
  }
})

function captureClick(event) {
  if (event.type === "auxclick" && event.button !== 1) return
  const link = event.target.closest("a[data-analytics-feature]")
  if (!link) return

  capture("feature_used", {
    ...propertiesFor(link),
    feature: link.dataset.analyticsFeature
  })
}

document.addEventListener("click", captureClick)
document.addEventListener("auxclick", captureClick)

// Delegation survives Turbo body replacements without adding duplicate listeners.
document.addEventListener("submit", (event) => {
  const form = event.target.closest("form[data-analytics-feature]")
  if (!form) return

  if (form.dataset.analyticsFeature === "search_deputies") {
    const query = form.querySelector("[name='q']")?.value.trim() || ""
    if (query) capture("feature_used", { feature: "search_deputies" })
    return
  }

  const type = form.querySelector("[name='expense_type_id']")
  capture("feature_used", {
    feature: form.dataset.analyticsFeature,
    expense_type_id: type?.value || null,
    expense_type: type?.selectedOptions[0]?.textContent.trim() || null
  })
}, true)
