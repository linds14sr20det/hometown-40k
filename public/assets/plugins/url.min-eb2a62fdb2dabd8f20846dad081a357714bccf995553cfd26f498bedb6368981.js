!function(n){"function"==typeof define&&define.amd?define(["jquery"],n):"object"==typeof module&&module.exports?module.exports=function(e,t){return void 0===t&&(t="undefined"!=typeof window?require("jquery"):require("jquery")(e)),n(t)}:n(window.jQuery)}(function(s){s.FE.URLRegEx="(^| |\\u00A0)("+s.FE.LinkRegEx+"|([a-z0-9+-_.]{1,}@[a-z0-9+-_.]{1,}))$",s.FE.PLUGINS.url=function(i){function t(e,t,n){for(var r="";n.length&&"."==n[n.length-1];)r+=".",n=n.substring(0,n.length-1);var o=n;return i.opts.linkConvertEmailAddress&&s.FE.MAIL_REGEX.test(o)&&!/^mailto:.*/i.test(o)&&(o="mailto:"+o),/^((http|https|ftp|ftps|mailto|tel|sms|notes|data)\:)/i.test(o)||(o="//"+o),(t||"")+"<a"+(i.opts.linkAlwaysBlank?' target="_blank"':"")+(u?' rel="'+u+'"':"")+' href="'+o+'">'+n.replace(/</g,"&lt;").replace(/>/g,"&gt;")+"</a>"+r}function n(){return new RegExp(s.FE.URLRegEx,"gi")}function o(e){return i.opts.linkAlwaysNoFollow&&(u="nofollow"),i.opts.linkAlwaysBlank&&(u?u+=" noopener noreferrer":u="noopener noreferrer"),e.replace(n(),t)}function r(e){return!!e&&("A"===e.tagName||!(!e.parentNode||e.parentNode==i.el)&&r(e.parentNode))}function l(e){var t=e.split(" ");return t[t.length-1]}function a(){var e=i.selection.ranges(0).startContainer;if(!e||e.nodeType!==Node.TEXT_NODE)return!1;if(r(e))return!1;if(n().test(l(e.textContent)))s(e).before(o(e.textContent)),e.parentNode.removeChild(e);else if(e.previousSibling&&"A"===e.previousSibling.tagName){var t=e.previousSibling.innerText+e.textContent;n().test(l(t))&&(s(e.previousSibling).replaceWith(o(t)),e.parentNode.removeChild(e))}}function e(){i.events.on("paste.afterCleanup",function(e){var t=i.doc.createElement("div");t.innerHTML=e;for(var n=i.doc.createTreeWalker(t,NodeFilter.SHOW_TEXT,i.node.filter(function(e){return new RegExp(s.FE.URLRegEx,"gi").test(e.textContent)}),!1);n.nextNode();){var r=n.currentNode;s(r).after(o(r.textContent)).remove()}return t.innerHTML}),i.events.on("keydown",function(e){var t=e.which;!i.selection.isCollapsed()||t!=s.FE.KEYCODE.ENTER&&t!=s.FE.KEYCODE.SPACE&&t!=s.FE.KEYCODE.PERIOD||a()},!0)}var u=null;return{_init:e}}});