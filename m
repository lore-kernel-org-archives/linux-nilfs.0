From: Eric A <eric225125-/E1597aS9LQAvxtiuMwx3w@public.gmane.org>
Subject: Re: df reports used space gradually growing.
Date: Sun, 26 Jul 2009 19:00:09 -0700 (PDT)
Message-ID: <450036.15299.qm@web58805.mail.re1.yahoo.com>
References: <675178.67834.qm@web58804.mail.re1.yahoo.com>
	<debc30fc0907260905w76ccec51g421ab08ecf3f67bd@mail.gmail.com>
	<288232.83823.qm@web58801.mail.re1.yahoo.com>
	<20090727.035744.118657598.ryusuke@osrg.net>
	<826723.64411.qm@web58808.mail.re1.yahoo.com>
	<874oszhsip.wl%jir@sekiba.com>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0807173985=="
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <874oszhsip.wl%jir-27yqGEOhnJbQT0dZR+AlfA@public.gmane.org>
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

--===============0807173985==
Content-Type: multipart/alternative; boundary="0-670723527-1248660009=:15299"

--0-670723527-1248660009=:15299
Content-Type: text/plain; charset=us-ascii

Ok, thanks that makes sense.  Well now that nilfs_cleanerd has been running for about 9 hours, it is actually starting to free up some space!  It's freed up about 1GB so far of the 12GB that should be freed.  So, I suppose it is working correctly, just rather slowly.  So, the only real problem is that it is not being started on mount, but for now I can just manually start it. 

Eric




________________________________
From: Jiro SEKIBA <jir-hfpbi5WX9J54Eiagz67IpQ@public.gmane.org>
To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Sent: Sunday, July 26, 2009 8:35:42 PM
Subject: Re: [NILFS users] df reports used space gradually growing.

Hi,

> Using lscp, I see no snapshots, but several thousand checkpoints.  I tried
> deleting the checkpoints with rmcp, but that didn't free up any space.  The
> disk is still slowly filling.

Unfortunately that's the way rmcp works for now.
rmcp only tells the cleanerd the checkpoint is ready to remove even
in the protection period and nilfs_cleanerd is the only process that
collect garage from the storage and create free space for new logs.

thanks,

regards,
-- 
Jiro SEKIBA <jir-hfpbi5WX9J54Eiagz67IpQ@public.gmane.org>
_______________________________________________
users mailing list
users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
https://www.nilfs.org/mailman/listinfo/users



      
--0-670723527-1248660009=:15299
Content-Type: text/html; charset=us-ascii

<html><head><style type="text/css"><!-- DIV {margin:0px;} --></style></head><body><div style="font-family:times new roman,new york,times,serif;font-size:12pt"><div>Ok, thanks that makes sense.&nbsp; Well now that nilfs_cleanerd has been running for about 9 hours, it is actually starting to free up some space!&nbsp; It's freed up about 1GB so far of the 12GB that should be freed.&nbsp; So, I suppose it is working correctly, just rather slowly.&nbsp; So, the only real problem is that it is not being started on mount, but for now I can just manually start it. <br><br>Eric<br></div><div style="font-family: times new roman,new york,times,serif; font-size: 12pt;"><br><div style="font-family: arial,helvetica,sans-serif; font-size: 13px;"><font face="Tahoma" size="2"><hr size="1"><b><span style="f
 ont-weight: bold;">From:</span></b> Jiro SEKIBA &lt;jir-hfpbi5WX9J54Eiagz67IpQ@public.gmane.org&gt;<br><b><span style="font-weight: bold;">To:</span></b> NILFS Users mailing list
 &lt;users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org&gt;<br><b><span style="font-weight: bold;">Sent:</span></b> Sunday, July 26, 2009 8:35:42 PM<br><b><span style="font-weight: bold;">Subject:</span></b> Re: [NILFS users] df reports used space gradually growing.<br></font><br>
Hi,<br><br>&gt; Using lscp, I see no snapshots, but several thousand checkpoints.&nbsp; I tried<br>&gt; deleting the checkpoints with rmcp, but that didn't free up any space.&nbsp; The<br>&gt; disk is still slowly filling.<br><br>Unfortunately that's the way rmcp works for now.<br>rmcp only tells the cleanerd the checkpoint is ready to remove even<br>in the protection period and nilfs_cleanerd is the only process that<br>collect garage from the storage and create free space for new logs.<br><br>thanks,<br><br>regards,<br>-- <br>Jiro SEKIBA &lt;<a ymailto="mailto:jir-hfpbi5WX9J54Eiagz67IpQ@public.gmane.org" href="mailto:jir-hfpbi5WX9J54Eiagz67IpQ@public.gmane.org">jir-hfpbi5WX9J54Eiagz67IpQ@public.gmane.org</a>&gt;<br>_______________________________________________<br>users mailing list<br><a ymailto="mailto:users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org" href="mailto:users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org">users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org</a><br><
 a href="https://www.nilfs.org/mailman/listinfo/users" target="_blank">https://www.nilfs.org/mailman/listinfo/users</a><br></div></div></div><br>

      </body></html>
--0-670723527-1248660009=:15299--


--===============0807173985==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
users mailing list
users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
https://www.nilfs.org/mailman/listinfo/users

--===============0807173985==--

