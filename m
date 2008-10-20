From: "Peter Smith" <smithpdo-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: System crashed by cleanerd
Date: Mon, 20 Oct 2008 09:24:51 +0200
Message-ID: <474dca090810200024p4c5a7b34lc89095864b6d4aaa@mail.gmail.com>
References: <20081017.160744.98074838.ryusuke@osrg.net>
	<474dca090810170106r692903cau90ce7aff109876af@mail.gmail.com>
	<474dca090810170141g75e26b22ke382dd74a865dfbe@mail.gmail.com>
	<20081018.142459.62714216.ryusuke@osrg.net>
	<474dca090810200008y3761208o6fde3f62bec7515c@mail.gmail.com>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1693179917=="
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <474dca090810200008y3761208o6fde3f62bec7515c-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
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
To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>

--===============1693179917==
Content-Type: multipart/alternative; 
	boundary="----=_Part_56536_31647889.1224487491291"

------=_Part_56536_31647889.1224487491291
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Cleanerd is active for about an hour even if I have made small changes to
the file system.
This is more an impression though, not a measurement.
It is not a problem for me, I am just curious.
I imagine that you are looking for a balance between updating the file
system
quickly and having a minimal impact on the system load.
regards, Peter
>
>
>
> On Sat, Oct 18, 2008 at 7:24 AM, Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org> wrote:
>
>> Hi,
>>
>> On Fri, 17 Oct 2008 10:41:48 +0200, "Peter Smith" wrote:
>> > Wonderful, many thanks, problem solved,  it works
>> > I have just installed nilfs-utils from the git repository.
>> > I am now able to mount my old nilfs partition and cleanerd is happily
>> > working in the background
>>
>> That's really nice ;-)
>>
>> > I have noticed, now and in the past, from my disk activity graphs, that
>> > cleanerd runs for quite a long time after writing to the Nilfs
>> partition. Is
>> > this to be expected?
>>
>> The current cleaner is quite "unsmart"; it selects segments to be
>> reclaimed in fifo order, and cleans them only 2 segments (= 16MB) per
>> 5 seconds by default.
>>
>> So, if you made a massive amount of changes to the file system or keep
>> large volume of snapshotted blocks on disk, that could be possible.
>>
>> If the cleaner never stops even though you leave the file system for
>> many hours, something would be wrong.
>>
>> Regards,
>> Ryusuke Konishi
>>
>
>
>
> --
> This is Linux land. On quiet nights you can hear the Windows machines
> rebooting.
>



-- 
This is Linux land. On quiet nights you can hear the Windows machines
rebooting.

------=_Part_56536_31647889.1224487491291
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

<div dir="ltr">Cleanerd is active for about an hour even if I have made small changes to the file system.<br>This is more an impression though, not a measurement.<br>It is not a problem for me, I am just curious.<br>I imagine that you are looking for a balance between updating the file system<br>

quickly and having a minimal impact on the system load.<br>regards, Peter<div class="gmail_quote"><blockquote class="gmail_quote" style="border-left: 1px solid rgb(204, 204, 204); margin: 0pt 0pt 0pt 0.8ex; padding-left: 1ex;">
<div dir="ltr"><div><div></div><div class="Wj3C7c"><br><br><div class="gmail_quote">On Sat, Oct 18, 2008 at 7:24 AM, Ryusuke Konishi <span dir="ltr">&lt;<a href="mailto:ryusuke-sG5X7nlA6pw@public.gmane.org" target="_blank">ryusuke-sG5X7nlA6pw@public.gmane.org</a>&gt;</span> wrote:<br>

<blockquote class="gmail_quote" style="border-left: 1px solid rgb(204, 204, 204); margin: 0pt 0pt 0pt 0.8ex; padding-left: 1ex;">Hi,<br>
<div><br>
On Fri, 17 Oct 2008 10:41:48 +0200, &quot;Peter Smith&quot; wrote:<br>
&gt; Wonderful, many thanks, problem solved, &nbsp;it works<br>
&gt; I have just installed nilfs-utils from the git repository.<br>
&gt; I am now able to mount my old nilfs partition and cleanerd is happily<br>
&gt; working in the background<br>
<br>
</div>That&#39;s really nice ;-)<br>
<div><br>
&gt; I have noticed, now and in the past, from my disk activity graphs, that<br>
&gt; cleanerd runs for quite a long time after writing to the Nilfs partition. Is<br>
&gt; this to be expected?<br>
<br>
</div>The current cleaner is quite &quot;unsmart&quot;; it selects segments to be<br>
reclaimed in fifo order, and cleans them only 2 segments (= 16MB) per<br>
5 seconds by default.<br>
<br>
So, if you made a massive amount of changes to the file system or keep<br>
large volume of snapshotted blocks on disk, that could be possible.<br>
<br>
If the cleaner never stops even though you leave the file system for<br>
many hours, something would be wrong.<br>
<br>
Regards,<br>
<font color="#888888">Ryusuke Konishi<br>
</font></blockquote></div><br><br clear="all"><br></div></div><div class="Ih2E3d">-- <br>This is Linux land. On quiet nights you can hear the Windows machines rebooting.<br>
</div></div>
</blockquote></div><br><br clear="all"><br>-- <br>This is Linux land. On quiet nights you can hear the Windows machines rebooting.<br>
</div>

------=_Part_56536_31647889.1224487491291--

--===============1693179917==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
users mailing list
users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
https://www.nilfs.org/mailman/listinfo/users

--===============1693179917==--
