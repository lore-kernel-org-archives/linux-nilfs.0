From: James M Long <james.m.long-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: NILFS usage on NAND and NOR flash memory
Date: Wed, 24 Jun 2009 10:33:07 -0400
Message-ID: <ddfcb4780906240733o73a2730fr299fbee54f6f9efb@mail.gmail.com>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1389365065=="
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
List-Id: <linux-nilfs.vger.kernel.org>
List-Unsubscribe: <https://www.nilfs.org/mailman/listinfo/users>,
	<mailto:users-request-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org?subject=unsubscribe>
List-Archive: <https://www.nilfs.org/pipermail/users>
List-Post: <mailto:users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
List-Help: <mailto:users-request-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org?subject=help>
List-Subscribe: <https://www.nilfs.org/mailman/listinfo/users>,
	<mailto:users-request-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org?subject=subscribe>
Mime-version: 1.0
Sender: users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
Errors-To: users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
To: users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org

--===============1389365065==
Content-Type: multipart/alternative; boundary=001517510cc4646961046d18fc0f

--001517510cc4646961046d18fc0f
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Hello Jesse, I have been doing testing with sqlite on small nilfs ( not on
ARM ) partitions of about 1Gig in size so maybe I can be of some help.

> Good day everyone, I do hope this has not already been asked as I had
> trouble searching the archive, and nothing meaningful came up in a
> search.
>
> My question is this:
> I am using android on an ARM-based pda phone.
> Android works by having a system partition and a data partition. In
> our environment, everything is mounted loop, as we have everything
> sitting on an SD card formatted FAT for windows mobile (our launcher
> runs from windows mobile)
>
> How well would NILFS function as the loop data partition? We're
> looking at 128MB, and it is used extensively for cache and sqlite3
> database reads/writes. Currently we're using ext2, but it has issues
> with fault tolerance, and on a device that doesn't unmount on
> shutdown, faults happen every time you turn it off (lots of data
> corruption).
> ext3 was tried, but there were so many writes that the location of the
> journal on the SD card burned and the card became unusable.
>
> Does NILFS handle this kind of thing better? Is there a log that is
> constantly written and overwritten, or does it sort of log as it goes?
> My understanding of log-centric filesystems is better than a few days
> ago (but still have lots to learn), it treats the whole partition as a
> sequential loop for writes, with random access reads (right?). I would
> think this would work better than ext2 for load leveling too.
>
> Any ideas or suggestions would be greatly appreciated, my co-developer
> things it would be "doing unnecessary writes" and that ext2 "should
> work fine"... but I don't want to burn my card, and I'd like some
> better fault tolerance.
>
> Thanks all,
> Jesse Campbell
>
>
Well Jesse, I have been doing a lot of testing with various applications
including lucene indexes, postgresql databases and also sqlite3 databases.
From watching how all of these systems write to disk in the normal usage
case. ( No or limited use of in memory storage and most if not all changes
written to disk in real time ) I can tell you that you will be doing a lot
of writes to disk as you make changes to the sqlite db. Now if you are only
using sqlite as a storage mechanism, ie reading from the db upon application
startup and dumping the information back to disk upon app shutdown, you
shouldn't have to worry at all. On the other hand, if you are using it as a
normal db... your limited amount of space will require a lot of garbage
collection to prevent the partition from being filled. An example... one of
the applications that I have been testing will create a sqlite3 db of about
160M in size. The massive number of row inserts and updates to the db was
causing the 1Gig ( 976M formatted ) partition to be filled long before the
default setting for cleanerd got around to doing gc. Matter of fact the
partition would fill in less that 10 minutes.
Hopefully the above examples and information can be useful to you and anyone
else thinking about using sqlite on a nilfs partition.

James...

--001517510cc4646961046d18fc0f
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hello Jesse, I have been doing testing with sqlite on small nilfs ( not on =
ARM ) partitions of about 1Gig in size so maybe I can be of some help. <br>=
<blockquote style=3D"border-left: 1px solid rgb(204, 204, 204); margin: 0pt=
 0pt 0pt 0.8ex; padding-left: 1ex;" class=3D"gmail_quote">
<pre>Good day everyone, I do hope this has not already been asked as I had<=
br>trouble searching the archive, and nothing meaningful came up in a<br>se=
arch.<br><br>My question is this:<br>I am using android on an ARM-based pda=
 phone.<br>
Android works by having a system partition and a data partition. In<br>our =
environment, everything is mounted loop, as we have everything<br>sitting o=
n an SD card formatted FAT for windows mobile (our launcher<br>runs from wi=
ndows mobile)<br>
<br>How well would NILFS function as the loop data partition? We&#39;re<br>=
looking at 128MB, and it is used extensively for cache and sqlite3<br>datab=
ase reads/writes. Currently we&#39;re using ext2, but it has issues<br>
with fault tolerance, and on a device that doesn&#39;t unmount on<br>shutdo=
wn, faults happen every time you turn it off (lots of data<br>corruption).<=
br>ext3 was tried, but there were so many writes that the location of the<b=
r>
journal on the SD card burned and the card became unusable.<br><br>Does NIL=
FS handle this kind of thing better? Is there a log that is<br>constantly w=
ritten and overwritten, or does it sort of log as it goes?<br>My understand=
ing of log-centric filesystems is better than a few days<br>
ago (but still have lots to learn), it treats the whole partition as a<br>s=
equential loop for writes, with random access reads (right?). I would<br>th=
ink this would work better than ext2 for load leveling too.<br><br>Any idea=
s or suggestions would be greatly appreciated, my co-developer<br>
things it would be &quot;doing unnecessary writes&quot; and that ext2 &quot=
;should<br>work fine&quot;... but I don&#39;t want to burn my card, and I&#=
39;d like some<br>better fault tolerance.<br><br>Thanks all,<br>Jesse Campb=
ell</pre>
</blockquote><div><br>Well Jesse, I have been doing a lot of testing with v=
arious applications including lucene indexes, postgresql databases and also=
 sqlite3 databases. From watching how all of these systems write to disk in=
 the normal usage case. ( No or limited use of in memory storage and most i=
f not all changes written to disk in real time ) I can tell you that you wi=
ll be doing a lot of writes to disk as you make changes to the sqlite db. N=
ow if you are only using sqlite as a storage mechanism, ie reading from the=
 db upon application startup and dumping the information back to disk upon =
app shutdown, you shouldn&#39;t have to worry at all. On the other hand, if=
 you are using it as a normal db... your limited amount of space will requi=
re a lot of garbage collection to prevent the partition from being filled. =
An example... one of the applications that I have been testing will create =
a sqlite3 db of about 160M in size. The massive number of row inserts and u=
pdates to the db was causing the 1Gig ( 976M formatted ) partition to be fi=
lled long before the default setting for cleanerd got around to doing gc. M=
atter of fact the partition would fill in less that 10 minutes.<br>
Hopefully the above examples and information can be useful to you and anyon=
e else thinking about using sqlite on a nilfs partition.<br><br>James...<br=
></div>

--001517510cc4646961046d18fc0f--

--===============1389365065==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
users mailing list
users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
https://www.nilfs.org/mailman/listinfo/users

--===============1389365065==--
