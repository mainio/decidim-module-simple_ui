/*
******** This file is temporary until this PR is merged: ********
******** https://github.com/decidim/decidim/pull/17978 ********
********
All 3 files inside this module's packs/src/decidim/comments are part of this
temporary fix. This fix prevents the 'Comment' -button on records' 'show' -views
from giving the comment -box the CSS class 'fullscreen' on desktop views.
Desktop view scrolls down to the comment -box element, mobile view makes the
comment -box fullscreen.
********
******** THIS FILE CAN BE DELETED AFTER PR - 17978 IS MERGED ********
*/

// The code: 1. Manages a responsive "Add Comment" modal: Opens fullscreen on mobile (<= sm) and closes it via a "close" button.
// 2. Handles dropdown menus: Dynamically updates button content based on user selection, hides selected items, and manages dropdown visibility.
// This creates a responsive, interactive comment interface with mobile-friendly design and dynamic user group selection.

import { initializeCommentsDropdown } from "src/decidim/comments/comments_dropdown";
import { isMobileScreen } from "src/decidim/comments/comments_screen_helper";

// Add comment card for mobile
const addCommentMobile = function (addCommentCard) {
  addCommentCard.classList.remove("hidden");
  addCommentCard.classList.add("fullscreen");
};

const closeAddComment = function (addCommentCard) {
  addCommentCard.classList.add("hidden");
  addCommentCard.classList.remove("fullscreen");
}

document.addEventListener("turbo:load", () => {
  // Add comment card for mobile
  const addCommentCard = document.getElementById("add-comment-anchor");
  if (addCommentCard) {
    document.querySelectorAll(".add-comment-mobile").forEach((addButtonMobile) => {
      addButtonMobile.addEventListener("click", () => {
        if (isMobileScreen()) {
          addCommentMobile(addCommentCard);
        }
      });
    });
  }

  // Close comment modal
  const closeButton = document.querySelector(
    "#add-comment-anchor .close-add-comment-fullscreen"
  );
  if (closeButton) {
    closeButton.addEventListener("click", () =>
      closeAddComment(addCommentCard)
    );
  }


  // Initialize dropdown menu
  initializeCommentsDropdown(document);
});
