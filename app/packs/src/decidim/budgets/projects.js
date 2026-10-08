document.addEventListener("turbo:load", () => {
  const $voteButtons = $(".customized-budget");
  const $budgetSummaryTotal = $(".budget-summary__total");
  const selectBudgetSummaryTotal = $budgetSummaryTotal.data("totalAllocation");
  const $budgetSummary = $(".budget-summary__progressbox");
  const totalAllocation = parseInt(selectBudgetSummaryTotal, 10);

  const cancelEvent = (event) => {
    event.stopPropagation();
    event.preventDefault();
  };
  $voteButtons.on("click", (event) => {
    const currentAllocation = parseInt($budgetSummary.attr("data-current-allocation"), 10);
    const $currentTarget = $(event.currentTarget);
    const projectAllocation = parseInt($currentTarget.attr("data-allocation"), 10);

    if ($currentTarget.attr("disabled")) {
      cancelEvent(event);
    } else if (($currentTarget.attr("data-add") === "true") && ((currentAllocation + projectAllocation) > totalAllocation)) {
      window.Decidim.currentDialogs["budget-excess"].toggle()
      cancelEvent(event);
    }
  });
});
