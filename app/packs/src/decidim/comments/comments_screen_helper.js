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

import { screens } from "tailwindcss/defaultTheme";

const smBreakpoint = parseInt(screens.md.replace("px", ""), 10);

export const isMobileScreen = () => window.matchMedia(`(max-width: ${smBreakpoint}px)`).matches;
