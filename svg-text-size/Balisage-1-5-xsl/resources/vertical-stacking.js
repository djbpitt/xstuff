window.addEventListener('DOMContentLoaded', init, false);
function init() {
    const svgs = document.querySelectorAll('svg');
    for (var i = 0; i < svgs.length; i++) {
        h = svgs[i].getBBox().height;
        svgs[i].setAttribute('height', h);
    }
}