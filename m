From: "Peter Smith" <smithpdo-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Mount memory allocation error
Date: Thu, 3 Jul 2008 13:57:51 +0200
Message-ID: <474dca090807030457m2124a200hf57306256f21ed4a@mail.gmail.com>
References: <474dca090807030319w7ff440b0w1315c60fb7d56756@mail.gmail.com>
	<20080703.203027.100419265.ryusuke@osrg.net>
	<lur6abjil3.wl%kihara@osrg.net>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0843812912=="
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <lur6abjil3.wl%kihara-sG5X7nlA6pw@public.gmane.org>
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

--===============0843812912==
Content-Type: multipart/alternative; 
	boundary="----=_Part_8983_9385667.1215086271792"

------=_Part_8983_9385667.1215086271792
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

SUCCESS
I used the Suse rpm and everything worked perfectly.
I can only assume a mistake on my part.
Thank you very much for such a prompt and helpful response
Peter

On Thu, Jul 3, 2008 at 1:46 PM, Seiji Kihara <kihara-sG5X7nlA6pw@public.gmane.org> wrote:

> Hello Peter,
>
> At Thu, 03 Jul 2008 20:30:27 +0900 (JST),
> Ryusuke Konishi wrote:
> > Hi Peter,
> >
> > On Thu, 3 Jul 2008 12:19:53 +0200, "Peter Smith" wrote:
> > > Hi,
> > > I recently upgraded my memory from 2G to 4G and this made it necessary
> to
> > > change my kernel
> > > from
> > > 2.6.22.5-31-default
> > > to
> > > 2.6.22.5-31-bigsmp
> > >
> > > Now I cannot mount nilfs2 partitions.
> > > I get the error message:  mount.nilf2: ... ... Cannot allocate memory
> > >
> > > My environment is
> > > OpenSuse 10.3
> > > nilfs 2.02
> > > nilfs-utils 2.04
> > >
> > > Yes, I did recompile/install nilfs and nilfs-utils while using the
> bigsmp
> > > kernel.
> > > When I switch back to the default kernel mount.nilfs2 works normally,
> > > as does everything else.(but of course I don't have access to the full
> 4G
> > > memory)
> > >
> > > Your help would be greatly appreciated
> > > Peter
> >
> > Thank you for reporting this.
> > We are now trying to catch the problem.
> >
> > BTW, did you try our binary package for OpenSuse?
> > It is available on http://www.nilfs.org/pub/opensuse/.
> >
> > Does it incur the same problem?
>
> I had tested with our environment and no error occured.
> Could you please try our binary packages, and more information
> of your environment if error occurs?
>
> my log:
>
> % uname -r
> 2.6.22.5-31-bigsmp
> % rpm -q nilfs-kmp-bigsmp nilfs-utils
> nilfs-kmp-bigsmp-2.0.2_2.6.22.5_31-1
> nilfs-utils-2.0.4-1
> % head /proc/meminfo
> MemTotal:      4150384 kB
> MemFree:       3811844 kB
> Buffers:         16608 kB
> Cached:         254852 kB
> SwapCached:          0 kB
> Active:         119736 kB
> Inactive:       180004 kB
> HighTotal:     3276528 kB
> HighFree:      2982592 kB
> LowTotal:       873856 kB
> % head /proc/cpuinfo
> processor       : 0
> vendor_id       : GenuineIntel
> cpu family      : 6
> model           : 15
> model name      : Intel(R) Xeon(R) CPU            5130  @ 2.00GHz
> stepping        : 6
> cpu MHz         : 2000.251
> cache size      : 4096 KB
> physical id     : 0
> siblings        : 2
> % dd if=/dev/zero of=nilfs2.vol bs=1048576 seek=1024 count=0
> 0+0 records in
> 0+0 records out
> 0 bytes (0 B) copied, 1.4095e-05 s, 0.0 kB/s
> % mkfs -t nilfs2 nilfs2.vol
> mkfs.nilfs2 ver 2.0
> Start writing file system initial data to the device
>       Blocksize:4096  Device:nilfs2.vol  Device Size:1073741824
> File system initialization succeeded !!
> % sudo mount -t nilfs2 -o loop nilfs2.vol /a
> % df /a
> Filesystem           1K-blocks      Used Available Use% Mounted on
> /dev/loop0             1048572     16380    966656   2% /a
>
> Regards,
>
> Seiji Kihara
> NILFS Team, NTT Labs.
> _______________________________________________
> users mailing list
> users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
> https://www.nilfs.org/mailman/listinfo/users
>



-- 
This is Linux land. On quiet nights you can hear the Windows machines
rebooting.

------=_Part_8983_9385667.1215086271792
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

SUCCESS<br>I used the Suse rpm and everything worked perfectly.<br>I can only assume a mistake on my part.<br>Thank you very much for such a prompt and helpful response<br>Peter<br><br><div class="gmail_quote">On Thu, Jul 3, 2008 at 1:46 PM, Seiji Kihara &lt;<a href="mailto:kihara-sG5X7nlA6pw@public.gmane.org">kihara-sG5X7nlA6pw@public.gmane.org</a>&gt; wrote:<br>
<blockquote class="gmail_quote" style="border-left: 1px solid rgb(204, 204, 204); margin: 0pt 0pt 0pt 0.8ex; padding-left: 1ex;">Hello Peter,<br>
<br>
At Thu, 03 Jul 2008 20:30:27 +0900 (JST),<br>
<div><div></div><div class="Wj3C7c">Ryusuke Konishi wrote:<br>
&gt; Hi Peter,<br>
&gt;<br>
&gt; On Thu, 3 Jul 2008 12:19:53 +0200, &quot;Peter Smith&quot; wrote:<br>
&gt; &gt; Hi,<br>
&gt; &gt; I recently upgraded my memory from 2G to 4G and this made it necessary to<br>
&gt; &gt; change my kernel<br>
&gt; &gt; from<br>
&gt; &gt; 2.6.22.5-31-default<br>
&gt; &gt; to<br>
&gt; &gt; 2.6.22.5-31-bigsmp<br>
&gt; &gt;<br>
&gt; &gt; Now I cannot mount nilfs2 partitions.<br>
&gt; &gt; I get the error message: &nbsp;mount.nilf2: ... ... Cannot allocate memory<br>
&gt; &gt;<br>
&gt; &gt; My environment is<br>
&gt; &gt; OpenSuse 10.3<br>
&gt; &gt; nilfs 2.02<br>
&gt; &gt; nilfs-utils 2.04<br>
&gt; &gt;<br>
&gt; &gt; Yes, I did recompile/install nilfs and nilfs-utils while using the bigsmp<br>
&gt; &gt; kernel.<br>
&gt; &gt; When I switch back to the default kernel mount.nilfs2 works normally,<br>
&gt; &gt; as does everything else.(but of course I don&#39;t have access to the full 4G<br>
&gt; &gt; memory)<br>
&gt; &gt;<br>
&gt; &gt; Your help would be greatly appreciated<br>
&gt; &gt; Peter<br>
&gt;<br>
&gt; Thank you for reporting this.<br>
&gt; We are now trying to catch the problem.<br>
&gt;<br>
&gt; BTW, did you try our binary package for OpenSuse?<br>
&gt; It is available on <a href="http://www.nilfs.org/pub/opensuse/" target="_blank">http://www.nilfs.org/pub/opensuse/</a>.<br>
&gt;<br>
&gt; Does it incur the same problem?<br>
<br>
</div></div>I had tested with our environment and no error occured.<br>
Could you please try our binary packages, and more information<br>
of your environment if error occurs?<br>
<br>
my log:<br>
<br>
% uname -r<br>
<div class="Ih2E3d">2.6.22.5-31-bigsmp<br>
</div>% rpm -q nilfs-kmp-bigsmp nilfs-utils<br>
nilfs-kmp-bigsmp-2.0.2_2.6.22.5_31-1<br>
nilfs-utils-2.0.4-1<br>
% head /proc/meminfo<br>
MemTotal: &nbsp; &nbsp; &nbsp;4150384 kB<br>
MemFree: &nbsp; &nbsp; &nbsp; 3811844 kB<br>
Buffers: &nbsp; &nbsp; &nbsp; &nbsp; 16608 kB<br>
Cached: &nbsp; &nbsp; &nbsp; &nbsp; 254852 kB<br>
SwapCached: &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;0 kB<br>
Active: &nbsp; &nbsp; &nbsp; &nbsp; 119736 kB<br>
Inactive: &nbsp; &nbsp; &nbsp; 180004 kB<br>
HighTotal: &nbsp; &nbsp; 3276528 kB<br>
HighFree: &nbsp; &nbsp; &nbsp;2982592 kB<br>
LowTotal: &nbsp; &nbsp; &nbsp; 873856 kB<br>
% head /proc/cpuinfo<br>
processor &nbsp; &nbsp; &nbsp; : 0<br>
vendor_id &nbsp; &nbsp; &nbsp; : GenuineIntel<br>
cpu family &nbsp; &nbsp; &nbsp;: 6<br>
model &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; : 15<br>
model name &nbsp; &nbsp; &nbsp;: Intel(R) Xeon(R) CPU &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;5130 &nbsp;@ 2.00GHz<br>
stepping &nbsp; &nbsp; &nbsp; &nbsp;: 6<br>
cpu MHz &nbsp; &nbsp; &nbsp; &nbsp; : 2000.251<br>
cache size &nbsp; &nbsp; &nbsp;: 4096 KB<br>
physical id &nbsp; &nbsp; : 0<br>
siblings &nbsp; &nbsp; &nbsp; &nbsp;: 2<br>
% dd if=/dev/zero of=nilfs2.vol bs=1048576 seek=1024 count=0<br>
0+0 records in<br>
0+0 records out<br>
0 bytes (0 B) copied, 1.4095e-05 s, 0.0 kB/s<br>
% mkfs -t nilfs2 nilfs2.vol<br>
mkfs.nilfs2 ver 2.0<br>
Start writing file system initial data to the device<br>
 &nbsp; &nbsp; &nbsp; Blocksize:4096 &nbsp;Device:nilfs2.vol &nbsp;Device Size:1073741824<br>
File system initialization succeeded !!<br>
% sudo mount -t nilfs2 -o loop nilfs2.vol /a<br>
% df /a<br>
Filesystem &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; 1K-blocks &nbsp; &nbsp; &nbsp;Used Available Use% Mounted on<br>
/dev/loop0 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; 1048572 &nbsp; &nbsp; 16380 &nbsp; &nbsp;966656 &nbsp; 2% /a<br>
<br>
Regards,<br>
<font color="#888888"><br>
Seiji Kihara<br>
NILFS Team, NTT Labs.<br>
</font><div><div></div><div class="Wj3C7c">_______________________________________________<br>
users mailing list<br>
<a href="mailto:users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org">users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org</a><br>
<a href="https://www.nilfs.org/mailman/listinfo/users" target="_blank">https://www.nilfs.org/mailman/listinfo/users</a><br>
</div></div></blockquote></div><br><br clear="all"><br>-- <br>This is Linux land. On quiet nights you can hear the Windows machines rebooting.

------=_Part_8983_9385667.1215086271792--

--===============0843812912==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
users mailing list
users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
https://www.nilfs.org/mailman/listinfo/users

--===============0843812912==--
