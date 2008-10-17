From: "Peter Smith" <smithpdo-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: System crashed by cleanerd
Date: Fri, 17 Oct 2008 10:41:48 +0200
Message-ID: <474dca090810170141g75e26b22ke382dd74a865dfbe@mail.gmail.com>
References: <474dca090810130444j1c3ab2a0rd5257f76153f63b@mail.gmail.com>
	<20081015.125249.23118089.ryusuke@osrg.net>
	<20081017.160744.98074838.ryusuke@osrg.net>
	<474dca090810170106r692903cau90ce7aff109876af@mail.gmail.com>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============2023929273=="
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <474dca090810170106r692903cau90ce7aff109876af-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
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
To: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>, NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>

--===============2023929273==
Content-Type: multipart/alternative; 
	boundary="----=_Part_33084_4922963.1224232908747"

------=_Part_33084_4922963.1224232908747
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Wonderful, many thanks, problem solved,  it works
I have just installed nilfs-utils from the git repository.
I am now able to mount my old nilfs partition and cleanerd is happily
working in the background

I have noticed, now and in the past, from my disk activity graphs, that
cleanerd runs for quite a long time after writing to the Nilfs partition. Is
this to be expected?

regards, Peter

On Fri, Oct 17, 2008 at 10:06 AM, Peter Smith <smithpdo-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> Many thanks for such a quick response
> regards, Peter
>
>
> On Fri, Oct 17, 2008 at 9:07 AM, Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org> wrote:
>
>> On Wed, 15 Oct 2008 12:52:49 +0900 (JST), Ryusuke Konishi wrote:
>> > On Mon, 13 Oct 2008 13:44:34 +0200, "Peter Smith" wrote:
>> > > After mounting my existing Nilfs2 partition,  which has been in use
>> for a
>> > > year,
>> > > as soon as cleanerd starts my entire system crashes.
>> >
>> > I found a related bug in the cleaner daemon and fixed it,
>> > but the cleaner still reproduces crash.
>>
>> I pushed another patch to the nilfs-utils git tree.
>> I believe it will fix the crash problem this time.
>>
>> Later I will bump the version of nilfs-utils to 2.0.6.
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

------=_Part_33084_4922963.1224232908747
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

<div dir="ltr">Wonderful, many thanks, problem solved,&nbsp; it works<br>I have just installed nilfs-utils from the git repository.<br>I am now able to mount my old nilfs partition and cleanerd is happily working in the background<br>
<br>I have noticed, now and in the past, from my disk activity graphs, that cleanerd runs for quite a long time after writing to the Nilfs partition. Is this to be expected?<br><br>regards, Peter<br><br><div class="gmail_quote">
On Fri, Oct 17, 2008 at 10:06 AM, Peter Smith <span dir="ltr">&lt;<a href="mailto:smithpdo-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org">smithpdo-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org</a>&gt;</span> wrote:<br><blockquote class="gmail_quote" style="border-left: 1px solid rgb(204, 204, 204); margin: 0pt 0pt 0pt 0.8ex; padding-left: 1ex;">
<div dir="ltr">Many thanks for such a quick response<br>regards, Peter<div><div></div><div class="Wj3C7c"><br><br><div class="gmail_quote">On Fri, Oct 17, 2008 at 9:07 AM, Ryusuke Konishi <span dir="ltr">&lt;<a href="mailto:ryusuke-sG5X7nlA6pw@public.gmane.org" target="_blank">ryusuke-sG5X7nlA6pw@public.gmane.org</a>&gt;</span> wrote:<br>

<blockquote class="gmail_quote" style="border-left: 1px solid rgb(204, 204, 204); margin: 0pt 0pt 0pt 0.8ex; padding-left: 1ex;"><div>On Wed, 15 Oct 2008 12:52:49 +0900 (JST), Ryusuke Konishi wrote:<br>
&gt; On Mon, 13 Oct 2008 13:44:34 +0200, &quot;Peter Smith&quot; wrote:<br>
</div><div>&gt; &gt; After mounting my existing Nilfs2 partition, &nbsp;which has been in use for a<br>
&gt; &gt; year,<br>
&gt; &gt; as soon as cleanerd starts my entire system crashes.<br>
&gt;<br>
</div><div>&gt; I found a related bug in the cleaner daemon and fixed it,<br>
&gt; but the cleaner still reproduces crash.<br>
<br>
</div>I pushed another patch to the nilfs-utils git tree.<br>
I believe it will fix the crash problem this time.<br>
<br>
Later I will bump the version of nilfs-utils to <a href="http://2.0.6." target="_blank">2.0.6.</a><br>
<br>
Regards,<br>
<font color="#888888">Ryusuke Konishi<br>
</font></blockquote></div><br><br clear="all"><br></div></div><div class="Ih2E3d">-- <br>This is Linux land. On quiet nights you can hear the Windows machines rebooting.<br>
</div></div>
</blockquote></div><br><br clear="all"><br>-- <br>This is Linux land. On quiet nights you can hear the Windows machines rebooting.<br>
</div>

------=_Part_33084_4922963.1224232908747--

--===============2023929273==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
users mailing list
users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
https://www.nilfs.org/mailman/listinfo/users

--===============2023929273==--
