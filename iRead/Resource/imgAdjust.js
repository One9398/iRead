
var imgs = document.getElementsByTagName('img');
for (var i = 0; i < imgs.length; i++) {
    
    var img = imgs[i];
    img.style.display = 'inherit';

    if( img.width < 20 ){
        img.style.display='none';
    }
}
var styleElement = document.createElement('style');
styleElement.id = 'iReadStyle2';
document.documentElement.appendChild(styleElement);
styleElement.textContent = 'img {width:100%;height:100%;}';


