var enrries = [];
var imgs = document.getElementsByTagName('img');
for (var i = 0; i < imgs.length; i++) {
    
    var img = imgs[i];
    if( img.width < 20 ){
        img.style.display='none';
    } else if ((img.src.indexOf('png') > -1) || (img.src.indexOf('jpg') > -1)|| (img.src.indexOf('gif') > -1)) {
        var entry = {
            'title': img.alt,
            'srcString': img.src};
        enrries.push(entry);
    }
}

webkit.messageHandlers.didFetchImagesOfContents.postMessage(enrries)


