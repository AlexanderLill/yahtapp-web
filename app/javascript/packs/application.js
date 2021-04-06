// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.


// Alpine JS Framework and Adapter to make it work on turbolinks pages
import 'alpine-turbo-drive-adapter'
import "alpinejs"

// Fontawesome
import "@fortawesome/fontawesome-pro/js/all"
// prevents the flickering of icons when using Fontawesome with turbolinks
// see: https://fontawesome.com/how-to-use/on-the-web/using-with/turbolinks
FontAwesome.config.mutateApproach = "sync"

import Rails from "@rails/ujs"
import Turbolinks from "turbolinks"
import * as ActiveStorage from "@rails/activestorage"
import "channels"

// custom components
import "./Notification"

Rails.start()
Turbolinks.start()
ActiveStorage.start()

document.addEventListener("turbo:load", initiate)
document.addEventListener("turbolinks:load", initiate)
document.addEventListener("turbo:before-stream-render", initiate)
function initiate() {
    initiateChoices()
}
const choiceConfig = {
    addItems: true,
    duplicateItemsAllowed: false,
    removeItemButton: true,
    addItemFilter: "/[0-9]{1,2}:[0-9]{2}/m" // allows input in the format XX:XX
}

function initiateChoices() {
    if (document.querySelectorAll("input.js-choice").length !== 0) {
        // TODO: replace with Tagify.js https://github.com/yairEO/tagify
        //const choices = new Choices('input.js-choice', choiceConfig);
    }
}

import "stylesheets/application"
