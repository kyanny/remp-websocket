var ws = new WebSocket("ws://127.0.0.1:8080/");
ws.onopen = function(){};
ws.onmessage = function(msg){
    var txtNode = document.createTextNode(msg.data);
    var brNode = document.createElement('br');
    var cnode = document.getElementById('content');
    cnode.appendChild(txtNode);
    cnode.appendChild(brNode);

//    if (msg.data.indexOf("\t") != -1) { // sender != receiver
        document.title = document.title.replace(/\((\d+)\)$/, function(match) {
            return "("+ (Number(RegExp.$1) + 1) + ")";
        });
//    }
};

function send(evt){
    evt.preventDefault();
    var msg = document.getElementById('message').value;
    ws.send(msg);
    document.getElementById('message').value = "";
}
