/**
 * Created by Simon on 16/4/27.
 */

var imgs = document.getElementsByTagName('img');
for (var i = 0; i < imgs.length; i++) {
    
    var img = imgs[i];
    img.style.display='none';
    
}
var styleElement = document.createElement('style');
styleElement.id = 'iReadStyle3';
document.documentElement.appendChild(styleElement);