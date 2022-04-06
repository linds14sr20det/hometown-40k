/*!
 * froala_editor v3.1.0 (https://www.froala.com/wysiwyg-editor)
 * License https://froala.com/wysiwyg-editor/terms/
 * Copyright 2014-2020 Froala Labs
 */


!function(e,t){"object"==typeof exports&&"undefined"!=typeof module?t(require("froala-editor")):"function"==typeof define&&define.amd?define(["froala-editor"],t):t(e.FroalaEditor)}(this,function(c){"use strict";c=c&&c.hasOwnProperty("default")?c["default"]:c,Object.assign(c.DEFAULTS,{dragInline:!0}),c.PLUGINS.draggable=function(g){var d=g.$;function e(e){return!(!e.originalEvent||!e.originalEvent.target||e.originalEvent.target.nodeType!==Node.TEXT_NODE)||(e.target&&"A"===e.target.tagName&&1===e.target.childNodes.length&&"IMG"===e.target.childNodes[0].tagName&&(e.target=e.target.childNodes[0]),d(e.target).hasClass("fr-draggable")?(g.undo.canDo()||g.undo.saveStep(),g.opts.dragInline?g.$el.attr("contenteditable",!0):g.$el.attr("contenteditable",!1),g.opts.toolbarInline&&g.toolbar.hide(),d(e.target).addClass("fr-dragging"),g.browser.msie||g.browser.edge||g.selection.clear(),void e.originalEvent.dataTransfer.setData("text","Froala")):(e.preventDefault(),!1))}var p,v=function v(e){return!(e&&("HTML"===e.tagName||"BODY"===e.tagName||g.node.isElement(e)))};function m(e,t,r){if(g.opts.iframe){var n=g.helpers.getPX(g.$wp.find(".fr-iframe").css("padding-top")),a=g.helpers.getPX(g.$wp.find(".fr-iframe").css("padding-left"));e+=g.$iframe.offset().top+n,t+=g.$iframe.offset().left+a}p.offset().top!==e&&p.css("top",e),p.offset().left!==t&&p.css("left",t),p.width()!==r&&p.css("width",r)}function t(e){e.originalEvent.dataTransfer.dropEffect="move",g.opts.dragInline?(!function r(){for(var e=null,t=0;t<c.INSTANCES.length;t++)if((e=c.INSTANCES[t].$el.find(".fr-dragging")).length)return e.get(0)}()||g.browser.msie||g.browser.edge)&&e.preventDefault():(e.preventDefault(),function f(e){var t=g.doc.elementFromPoint(e.originalEvent.pageX-g.win.pageXOffset,e.originalEvent.pageY-g.win.pageYOffset);if(!v(t)){for(var r=0,n=t;!v(n)&&n===t&&0<e.originalEvent.pageY-g.win.pageYOffset-r;)r++,n=g.doc.elementFromPoint(e.originalEvent.pageX-g.win.pageXOffset,e.originalEvent.pageY-g.win.pageYOffset-r);(!v(n)||p&&0===g.$el.find(n).length&&n!==p.get(0))&&(n=null);for(var a=0,o=t;!v(o)&&o===t&&e.originalEvent.pageY-g.win.pageYOffset+a<d(g.doc).height();)a++,o=g.doc.elementFromPoint(e.originalEvent.pageX-g.win.pageXOffset,e.originalEvent.pageY-g.win.pageYOffset+a);(!v(o)||p&&0===g.$el.find(o).length&&o!==p.get(0))&&(o=null),t=null===o&&n?n:o&&null===n?o:o&&n?r<a?n:o:null}if(d(t).hasClass("fr-drag-helper"))return!1;if(t&&!g.node.isBlock(t)&&(t=g.node.blockParent(t)),t&&0<=["TD","TH","TR","THEAD","TBODY"].indexOf(t.tagName)&&(t=d(t).parents("table").get(0)),t&&0<=["LI"].indexOf(t.tagName)&&(t=d(t).parents("UL, OL").get(0)),t&&!d(t).hasClass("fr-drag-helper")){var i;p||(c.$draggable_helper||(c.$draggable_helper=d(document.createElement("div")).attr("class","fr-drag-helper")),p=c.$draggable_helper,g.events.on("shared.destroy",function(){p.html("").removeData().remove(),p=null},!0)),i=e.originalEvent.pageY<d(t).offset().top+d(t).outerHeight()/2;var l=d(t),s=0;i||0!==l.next().length?(i||(l=l.next()),"before"===p.data("fr-position")&&l.is(p.data("fr-tag"))||(0<l.prev().length&&(s=parseFloat(l.prev().css("margin-bottom"))||0),s=Math.max(s,parseFloat(l.css("margin-top"))||0),m(l.offset().top-s/2-g.$box.offset().top,l.offset().left-g.win.pageXOffset-g.$box.offset().left,l.width()),p.data("fr-position","before"))):"after"===p.data("fr-position")&&l.is(p.data("fr-tag"))||(s=parseFloat(l.css("margin-bottom"))||0,m(l.offset().top+d(t).height()+s/2-g.$box.offset().top,l.offset().left-g.win.pageXOffset-g.$box.offset().left,l.width()),p.data("fr-position","after")),p.data("fr-tag",l),p.addClass("fr-visible"),g.$box.append(p)}else p&&0<g.$box.find(p).length&&p.removeClass("fr-visible")}(e))}function r(e){e.originalEvent.dataTransfer.dropEffect="move",g.opts.dragInline||e.preventDefault()}function n(e){g.$el.attr("contenteditable",!0);var t=g.$el.find(".fr-dragging");p&&p.hasClass("fr-visible")&&g.$box.find(p).length?a(e):t.length&&(e.preventDefault(),e.stopPropagation()),p&&g.$box.find(p).length&&p.removeClass("fr-visible"),t.removeClass("fr-dragging")}function a(e){var t,r;g.$el.attr("contenteditable",!0);for(var n=0;n<c.INSTANCES.length;n++)if((t=c.INSTANCES[n].$el.find(".fr-dragging")).length){r=c.INSTANCES[n];break}if(t.length){if(e.preventDefault(),e.stopPropagation(),p&&p.hasClass("fr-visible")&&g.$box.find(p).length)p.data("fr-tag")[p.data("fr-position")]('<span class="fr-marker"></span>'),p.removeClass("fr-visible");else if(!1===g.markers.insertAtPoint(e.originalEvent))return!1;if(t.removeClass("fr-dragging"),!1===(t=g.events.chainTrigger("element.beforeDrop",t)))return!1;var a=t;if(t.parent().is("A")&&1===t.parent().get(0).childNodes.length&&(a=t.parent()),g.core.isEmpty())g.events.focus();else g.$el.find(".fr-marker").replaceWith(c.MARKERS),g.selection.restore();if(r===g||g.undo.canDo()||g.undo.saveStep(),g.core.isEmpty())g.$el.html(a);else{var o=g.markers.insert();0===a.find(o).length?d(o).replaceWith(a):0===t.find(o).length&&d(o).replaceWith(t),t.after(c.MARKERS),g.selection.restore()}return g.popups.hideAll(),g.selection.save(),g.$el.find(g.html.emptyBlockTagsQuery()).not("TD, TH, LI, .fr-inner").not(g.opts.htmlAllowedEmptyTags.join(",")).remove(),g.html.wrap(),g.html.fillEmptyBlocks(),g.selection.restore(),g.undo.saveStep(),g.opts.iframe&&g.size.syncIframe(),r!==g&&(r.popups.hideAll(),r.$el.find(r.html.emptyBlockTagsQuery()).not("TD, TH, LI, .fr-inner").remove(),r.html.wrap(),r.html.fillEmptyBlocks(),r.undo.saveStep(),r.events.trigger("element.dropped"),r.opts.iframe&&r.size.syncIframe()),g.events.trigger("element.dropped",[a]),!1}p&&p.removeClass("fr-visible"),g.undo.canDo()||g.undo.saveStep(),setTimeout(function(){g.undo.saveStep()},0)}function o(e){if(e&&"DIV"===e.tagName&&g.node.hasClass(e,"fr-drag-helper"))e.parentNode.removeChild(e);else if(e&&e.nodeType===Node.ELEMENT_NODE)for(var t=e.querySelectorAll("div.fr-drag-helper"),r=0;r<t.length;r++)t[r].parentNode.removeChild(t[r])}return{_init:function i(){g.opts.enter===c.ENTER_BR&&(g.opts.dragInline=!0),g.events.on("dragstart",e,!0),g.events.on("dragover",t,!0),g.events.on("dragenter",r,!0),g.events.on("document.dragend",n,!0),g.events.on("document.drop",n,!0),g.events.on("drop",a,!0),g.events.on("html.processGet",o)}}}});