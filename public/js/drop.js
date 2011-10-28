// drag
var drag = document.getElementById('drag');
for (var i = 0; i < drag.childNodes.length; i++) {
    var node = drag.childNodes[i];
    node.addEventListener('click', function(event){
        event.preventDefault();
        return false;
    });
    node.setAttribute('draggable', true);
    node.addEventListener('dragstart', function(event){
        // event.dataTransfer.setData('song', node.innerHTML); // not work at Google Chrome :( # dataTransfer is Clipboard
        setData('song', node.innerHTML);
    });
}

// drop
var drop = document.getElementById('drop');

drop.addEventListener('drop', function(event){
    event.preventDefault();
    event.stopPropagation();
    
    onDrop(event, ws); // fire
}, false);

drop.addEventListener('dragover', function(event){
    event.preventDefault();
    event.stopPropagation();
    return false;
}, false);

// dataTransfer
function setData(key, value) {
    var stack = document.getElementById('stack');
    var data = {};
    data[key] = value;
    stack.value = JSON.stringify(data);
}

function getData(key) {
    var stack = document.getElementById('stack');
    var data = JSON.parse(stack.value);
    return data[key];
}

// event handler
function onDrop(event, ws){
    var song = getData('song');
    var sid = document.getElementById('rack.session').value;
    var msg = [sid, 'これいいよ！'+song].join(':');
    ws.send(msg);
}