#!/usr/bin/env perl
use Mojolicious::Lite -signatures;
use POSIX qw(strftime);

my $users = {};

get '/' => 'index';

websocket '/websocket' => sub {
    my $self = shift;
    
    $self->inactivity_timeout(300);
    
    my $id = sprintf "%s", $self->tx;
    $users->{$id} = $self->tx;
    
    $self->on(message => sub {
        my ($self, $param) = @_;
        my $dt = strftime "%H:%M:%S", localtime;
        
        my ($name,$msg) = split /\|/,$param;
        
        for (keys %$users) {
            $users->{$_}->send({json => {
                time     => $dt,
                name     => $name,
                chatmsg  => $msg
            }});
        }
    });
    
    $self->on(finish => sub {
        delete $users->{$id};
    });
};

app->start;

__DATA__
@@ index.html.ep
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="utf-8">
    <title>Websockets Demo</title>
    <style type="text/css">
        textarea {
            width: 40em;
            height: 50em;
        }
    </style>
</head>

<body>
    <h1>Chat</h1>
    <div id="welcome"></div>
    <input type="hidden" id="namenew" placeholder="Name" />
    
    <form onSubmit="return connectToChat()">
        <div id="connectbtn">
            <input type="text" id="name" placeholder="Enter your name" />
            <input id="submit" type="submit" value="Connect">
        </div>
    </form>
    
    <form name="sendform" onSubmit="return sendMsg()">
        <div id="sendMsgbtn">
            <input type="text" id="msg" placeholder="Message" />
            <input id="submit2" type="submit" value="Send">
        </div>
    </form>
    
    <textarea id="chatwindow" readonly></textarea>
    
    <script type="text/javascript">
        var ws;
        
        var x = document.getElementById("sendMsgbtn");
        x.style.display = "none";
        function connectToChat() {
            ws = new WebSocket('<%= url_for('websocket')->to_abs %>');
            ws.onopen = function (event) {
                document.getElementById("chatwindow").innerHTML = "Client Connected\n";
            };
            ws.onclose = function () {
                document.getElementById("chatwindow").innerHTML += "Connection Closed due to inactivity\n";
                alert("Connection is closed.");
            };
            ws.onmessage = function (event) {
                var res = JSON.parse(event.data);
                document.getElementById("chatwindow").innerHTML += res.name + ' [' + res.time + ']: ' + res.chatmsg + "\n";
            };
            
            var name = document.getElementById("name").value;
            document.getElementById("connectbtn").innerHTML = "";
            document.getElementById("welcome").innerHTML = "<h2><font color=blue>Hello " + name + "</font></h2>";
            document.getElementById("namenew").value = name;
            document.getElementById("sendMsgbtn").style.display = "block";
            return false;
        }
        
        function sendMsg() {
            ws.send(document.getElementById("namenew").value + '|' + document.getElementById("msg").value);
            document.getElementById("msg").value = "";

            return false;
        }
    </script>
</body>

</html>
