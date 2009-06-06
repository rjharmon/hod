package Hod::DB;
use UNIVERSAL qw(isa);
use DBI;
use Exporter;
use Apache::Reload;
@ISA=qw(Exporter);

use Hod::Field::Checkbox;
use Hod::Field::Date;
use Hod::Field::Pulldown;
use Hod::Field::Textbox;
use Hod::Field::File_Upload;

sub TEXT { 'text' };
sub ID  { 'id' };
sub NUMBER { 'numeric' };
sub MONEY { 'money' };
sub CHECKBOX { 'Checkbox.pm' };
sub DATE { 'Date.pm' };
sub PULLDOWN {'Pulldown.pm' };
sub TEXTBOX { 'Textbox.pm' };
sub FILE_UPLOAD { 'File_Upload.pm' };

sub field_type {
	my $field = shift;
	my $primary = shift;
	if( $field =~ s/\.pm$// ) {
		my $c = "Hod::Field::$field";
		return eval { $c->default_field_type() } || undef;
	} else {
		return {
			text => 'varchar(255) NOT NULL',
			id => 'int(8) NOT NULL',
			money => 'DECIMAL(10,2) NOT NULL',
		}->{$field} . ( $field eq 'id' && $primary ? " auto_increment" : "" );
	}
}

@EXPORT= qw(db_connect db_disconnect db_query db_do cgi_escape cgi_unescape db_quote TEXT TEXTBOX ID DATE PULLDOWN NUMBER MONEY CHECKBOX FILE_UPLOAD);
use strict;


# database connection routines for general use

$Hod::DB::DEBUG = 0;
$Hod::DB::DBH = undef;

sub db_connect {
	my $self; $self = shift if ref($_[0]);
	my( $db, $user, $password, $host ) = @_;

	warn "connecting to $db on ${host}...\n" if $Hod::DB::DEBUG > 2;
	if( $self ) {
		$self->{_dbh} = DBI->connect('dbi:mysql:'. $db . ( $host ? ':' . $host : ""), $user, $password );
		return $self->{_dbh};
	} else {
		$HTML::Mason::Commands::dbh->disconnect if ref( $HTML::Mason::Commands::dbh );
		$HTML::Mason::Commands::dbh = DBI->connect('dbi:mysql:'. $db . ( $host ? ':' . $host : ""), $user, $password );
		return $HTML::Mason::Commands::dbh;
	}
}

sub db_disconnect {
	my $self = shift || {};
	warn "disconnecting" if $Hod::DB::DEBUG > 2;
	my $dbh = $self->{_dbh} || $HTML::Mason::Commands::dbh;
	$dbh->disconnect if $Hod::DB::DBH;
	$dbh = undef;
}

sub db_query {
	my( $self, $sql ) = @_;
	$sql = $self, $self = {} unless $sql;

	my $dbh = $self->{_dbh} || $HTML::Mason::Commands::dbh;
	warn "query: $sql\n" if $Hod::DB::DEBUG > 1;
	my $sth = $dbh->prepare( $sql ) 
		or ( Carp::cluck( "offending query: $sql\n" ), return undef );
	my $rc = $sth->execute()
		or ( Carp::cluck( "offending query: $sql\n" ), return undef );

	my( $row, $results );

	my $n;
	while ( $row = $sth->fetchrow_hashref() ) {
		push @$results,  $row;
		$n++;
	}
	warn "$n rows returned for query '$sql'\n" if $Hod::DB::DEBUG;
	$sth->finish();  # free up the query info.
	return $results;
}

sub db_do {
	my( $self, $sql ) = @_;
	$sql = $self, $self = {} unless $sql;

	my $dbh = $self->{_dbh} || $HTML::Mason::Commands::dbh;
	warn "db_do: $sql\n" if $Hod::DB::DEBUG;
	return $dbh->do( $sql );
  
}

sub cgi_escape {
    my $toencode = shift;
    return undef unless defined($toencode);
    $toencode=~s/([^a-zA-Z0-9_.-])/uc sprintf("%%%02x",ord($1))/eg;
    return $toencode;
}

sub cgi_unescape {
    my $todecode = shift;
    return undef unless defined($todecode);
    $todecode =~ s/%([0-9a-fA-F]{2})/pack("c",hex($1))/ge;
    return $todecode;
}

sub db_quote {
	my $self = shift;
  my $toescape = shift;
	unless( $toescape ) {
		$toescape = $self;
	}
	my $dbh = eval { $self->{_dbh} } || $HTML::Mason::Commands::dbh;
  return $dbh->quote( $toescape );
}

1;

=pod=

Copyright 1999-2009 Randy Harmon

Hod is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or   
(at your option) any later version.

Hod is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the 
GNU General Public License for more details (in the LICENSE file).           
    
You should have received a copy of the GNU General Public License
along with Hod.  If not, see <http://www.gnu.org/licenses/>.

=cut=
