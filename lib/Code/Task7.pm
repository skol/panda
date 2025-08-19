package Code::Task7;
use strict;
use warnings;
use Errno qw(EAGAIN EWOULDBLOCK);
use IO::Socket::INET;
use IO::Poll;
use URI::Escape;

use Exporter qw(import);
 
our @EXPORT = qw(get_http get_http_async);


sub get_http {
    my ($host, $path, $query, $timeout_sec) = @_;
    $timeout_sec ||= 15;

    my ($real_host, $port) = $host =~ /([^:]+)(?::(\d+))?/;
    $port ||= 80;

    my $query_str = '';
    if (ref($query) eq 'HASH') {
        $query_str = join '&', map { "$_=" . uri_escape($query->{$_}) } keys %$query;
    } elsif (defined $query) {
        $query_str = uri_escape($query);
    }
    
    my $sock = IO::Socket::INET->new(
        PeerAddr => $host,
        PeerPort => $port,
        Proto    => 'tcp',
    ) or die "Ошибка сети: $@";

    my $request = "GET $path" . ($query_str ? "?$query_str" : "") . " HTTP/1.1\r\n"
                    . "Host: $host\r\n"
                    . "Connection: close\r\n"
                    . "\r\n";
    
    $sock->send($request) or die "\nНе могу отправить запрос: $!";
    my $received_data = '';
    while (1) {
        my $buf;
        my $bytes_received = $sock->recv($buf, 1024);
        last if !defined $bytes_received;
        $bytes_received = "$bytes_received" eq "" ? 0 : $bytes_received;
        $received_data .= $buf;
        last if $buf eq "";
        # last if $bytes_received < 1024; #  Дочитали до конца буфера, возможно еще есть данные
    }
    print "\n$received_data";
    $sock->close();
}

sub get_http_async {
    my ($host, $path, $query, $timeout_sec) = @_;
    $timeout_sec ||= 15;

    my ($real_host, $port) = $host =~ /([^:]+)(?::(\d+))?/;
    $port ||= 80;

    my $query_str = '';
    if (ref($query) eq 'HASH') {
        $query_str = join '&', map { "$_=" . uri_escape($query->{$_}) } keys %$query;
    } elsif (defined $query) {
        $query_str = uri_escape($query);
    }

    my $sock = IO::Socket::INET->new(
        PeerAddr => $real_host,
        PeerPort => $port,
        Proto    => 'tcp',
        Blocking => 0,
    ) or die "Не могу создать сокет: $@";

    my $poll = IO::Poll->new();
    $poll->mask($sock => POLLOUT | POLLERR);

    my $done       = 0;
    
    my $start_time = time();
    
    print "\n";

    while (time() - $start_time < $timeout_sec) {
        my $events = $poll->poll(1);
        if ($events) {
            if ($poll->events($sock) & POLLOUT) {
                # Можно начинать обмен данными
                last;
            } elsif ($poll->events($sock) & POLLERR) {
                $sock->close;
                warn("\nОшибка при установке соединения\n");
                return;
            }
        } else {
            # Соединение еще не установлено
            print(".")
        }
    }

    print("\n");

    my $request = "GET $path" . ($query_str ? "?$query_str" : "") . " HTTP/1.1\r\n"
                    . "Host: $host\r\n"
                    . "Connection: close\r\n"
                    . "\r\n";
    $sock->send($request) or die "\nНе могу отправить запрос: $!";
    $poll->mask($sock => POLLIN | POLLERR);

    my $received_data = '';

    while (time() - $start_time < $timeout_sec && !$done) {
        my $ready = $poll->poll(1);
        
        if (!$ready) {
            print ".";
            next;
        }

        my $events = $poll->events($sock);
        if ($events & POLLERR) {
            warn "\nСокет сообщил об ошибке";
            $done = 1;
            last;
        }
        
        if ($events & POLLIN) {
            while (1) {
                my $buf;
                my $bytes_received = $sock->recv($buf, 1024);
                last if !defined $bytes_received;
                $bytes_received = "$bytes_received" eq "" ? 0 : $bytes_received;
                $received_data .= $buf;
                # last if $bytes_received < 1024; #  Дочитали до конца буфера, возможно еще есть данные
                last if $buf eq "";
            }
            $done = 1;
            last;
        } else {
            print ".";
        }
    }
    if (!$done && time() - $start_time >= $timeout_sec) {
        print "\n[Таймаут: $timeout_sec секунд]\n";
    }
    print("\n$received_data\n");

    $sock->close();
}

1;
