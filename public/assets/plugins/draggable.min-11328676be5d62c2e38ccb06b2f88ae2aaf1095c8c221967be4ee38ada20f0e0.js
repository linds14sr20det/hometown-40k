!function(n){"function"==typeof define&&define.amd?define(["jquery"],n):"object"==typeof module&&module.exports?module.exports=function(e,t){return void 0===t&&(t="undefined"!=typeof window?require("jquery"):require("jquery")(e)),n(t)}:n(window.jQuery)}(function(v){v.extend(v.FE.DEFAULTS,{dragInline:!0}),v.FE.PLUGINS.draggable=function(f){function e(e){return!(!e.originalEvent||!e.originalEvent.target||e.originalEvent.target.nodeType!=Node.TEXT_NODE)||(e.target&&"A"==e.target.tagName&&1==e.target.childNodes.length&&"IMG"==e.target.childNodes[0].tagName&&(e.target=e.target.childNodes[0]),v(e.target).hasClass("fr-draggable")?(f.undo.canDo()||f.undo.saveStep(),f.opts.dragInline?f.$el.attr("contenteditable",!0):f.$el.attr("contenteditable",!1),f.opts.toolbarInline&&f.toolbar.hide(),v(e.target).addClass("fr-dragging"),f.browser.msie||f.browser.edge||f.selection.clear(),void e.originalEvent.dataTransfer.setData("text","Froala")):(e.preventDefault(),!1))}function g(e){return!(e&&("HTML"==e.tagName||"BODY"==e.tagName||f.node.isElement(e)))}function d(e,t,n){f.opts.iframe&&(e+=f.$iframe.offset().top,t+=f.$iframe.offset().left),p.offset().top!=e&&p.css("top",e),p.offset().left!=t&&p.css("left",t),p.width()!=n&&p.css("width",n)}function t(e){var t=f.doc.elementFromPoint(e.originalEvent.pageX-f.win.pageXOffset,e.originalEvent.pageY-f.win.pageYOffset);if(!g(t)){for(var n=0,r=t;!g(r)&&r==t&&0<e.originalEvent.pageY-f.win.pageYOffset-n;)n++,r=f.doc.elementFromPoint(e.originalEvent.pageX-f.win.pageXOffset,e.originalEvent.pageY-f.win.pageYOffset-n);(!g(r)||p&&0===f.$el.find(r).length&&r!=p.get(0))&&(r=null);for(var a=0,o=t;!g(o)&&o==t&&e.originalEvent.pageY-f.win.pageYOffset+a<v(f.doc).height();)a++,o=f.doc.elementFromPoint(e.originalEvent.pageX-f.win.pageXOffset,e.originalEvent.pageY-f.win.pageYOffset+a);(!g(o)||p&&0===f.$el.find(o).length&&o!=p.get(0))&&(o=null),t=null==o&&r?r:o&&null==r?o:o&&r?n<a?r:o:null}if(v(t).hasClass("fr-drag-helper"))return!1;if(t&&!f.node.isBlock(t)&&(t=f.node.blockParent(t)),t&&0<=["TD","TH","TR","THEAD","TBODY"].indexOf(t.tagName)&&(t=v(t).parents("table").get(0)),t&&0<=["LI"].indexOf(t.tagName)&&(t=v(t).parents("UL, OL").get(0)),t&&!v(t).hasClass("fr-drag-helper")){var i;p||(v.FE.$draggable_helper||(v.FE.$draggable_helper=v('<div class="fr-drag-helper"></div>')),p=v.FE.$draggable_helper,f.events.on("shared.destroy",function(){p.html("").removeData().remove(),p=null},!0)),i=e.originalEvent.pageY<v(t).offset().top+v(t).outerHeight()/2;var l=v(t),s=0;i||0!==l.next().length?(i||(l=l.next()),"before"==p.data("fr-position")&&l.is(p.data("fr-tag"))||(0<l.prev().length&&(s=parseFloat(l.prev().css("margin-bottom"))||0),s=Math.max(s,parseFloat(l.css("margin-top"))||0),d(l.offset().top-s/2-f.$box.offset().top,l.offset().left-f.win.pageXOffset-f.$box.offset().left,l.width()),p.data("fr-position","before"))):"after"==p.data("fr-position")&&l.is(p.data("fr-tag"))||(s=parseFloat(l.css("margin-bottom"))||0,d(l.offset().top+v(t).height()+s/2-f.$box.offset().top,l.offset().left-f.win.pageXOffset-f.$box.offset().left,l.width()),p.data("fr-position","after")),p.data("fr-tag",l),p.addClass("fr-visible"),p.appendTo(f.$box)}else p&&0<f.$box.find(p).length&&p.removeClass("fr-visible")}function n(e){e.originalEvent.dataTransfer.dropEffect="move",f.opts.dragInline?o()||!f.browser.msie&&!f.browser.edge||e.preventDefault():(e.preventDefault(),t(e))}function r(e){e.originalEvent.dataTransfer.dropEffect="move",f.opts.dragInline||e.preventDefault()}function a(e){f.$el.attr("contenteditable",!0);var t=f.$el.find(".fr-dragging");p&&p.hasClass("fr-visible")&&f.$box.find(p).length?i(e):t.length&&(e.preventDefault(),e.stopPropagation()),p&&f.$box.find(p).length&&p.removeClass("fr-visible"),t.removeClass("fr-dragging")}function o(){for(var e=null,t=0;t<v.FE.INSTANCES.length;t++)if((e=v.FE.INSTANCES[t].$el.find(".fr-dragging")).length)return e.get(0)}function i(e){for(var t,n,r=0;r<v.FE.INSTANCES.length;r++)if((t=v.FE.INSTANCES[r].$el.find(".fr-dragging")).length){n=v.FE.INSTANCES[r];break}if(t.length){if(e.preventDefault(),e.stopPropagation(),p&&p.hasClass("fr-visible")&&f.$box.find(p).length)p.data("fr-tag")[p.data("fr-position")]('<span class="fr-marker"></span>'),p.removeClass("fr-visible");else if(!1===f.markers.insertAtPoint(e.originalEvent))return!1;t.removeClass("fr-dragging");var a=t;if(t.parent().is("A")&&(a=t.parent()),f.core.isEmpty()?f.events.focus():(f.$el.find(".fr-marker").replaceWith(v.FE.MARKERS),f.selection.restore()),n==f||f.undo.canDo()||f.undo.saveStep(),f.core.isEmpty())f.$el.html(a);else{var o=f.markers.insert();0===a.find(o).length?v(o).replaceWith(a):v(o).replaceWith(t),t.after(v.FE.MARKERS),f.selection.restore()}return f.popups.hideAll(),f.selection.save(),f.$el.find(f.html.emptyBlockTagsQuery()).not("TD, TH, LI, .fr-inner").remove(),f.html.wrap(),f.html.fillEmptyBlocks(),f.selection.restore(),f.undo.saveStep(),f.opts.iframe&&f.size.syncIframe(),n!=f&&(n.popups.hideAll(),n.$el.find(n.html.emptyBlockTagsQuery()).not("TD, TH, LI, .fr-inner").remove(),n.html.wrap(),n.html.fillEmptyBlocks(),n.undo.saveStep(),n.events.trigger("element.dropped"),n.opts.iframe&&n.size.syncIframe()),f.events.trigger("element.dropped",[a]),!1}p&&p.removeClass("fr-visible"),f.undo.canDo()||f.undo.saveStep(),setTimeout(function(){f.undo.saveStep()},0)}function l(e){if(e&&"DIV"==e.tagName&&f.node.hasClass(e,"fr-drag-helper"))e.parentNode.removeChild(e);else if(e&&e.nodeType==Node.ELEMENT_NODE)for(var t=e.querySelectorAll("div.fr-drag-helper"),n=0;n<t.length;n++)t[n].parentNode.removeChild(t[n])}function s(){f.opts.enter==v.FE.ENTER_BR&&(f.opts.dragInline=!0),f.events.on("dragstart",e,!0),f.events.on("dragover",n,!0),f.events.on("dragenter",r,!0),f.events.on("document.dragend",a,!0),f.events.on("document.drop",a,!0),f.events.on("drop",i,!0),f.events.on("html.processGet",l)}var p;return{_init:s}}});