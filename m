From: Eric A <eric225125-/E1597aS9LQAvxtiuMwx3w@public.gmane.org>
Subject: segctord problem
Date: Tue, 11 Aug 2009 15:06:59 -0700 (PDT)
Message-ID: <949415.6494.qm@web58808.mail.re1.yahoo.com>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0228946958=="
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

--===============0228946958==
Content-Type: multipart/alternative; boundary="0-187015945-1250028419=:6494"

--0-187015945-1250028419=:6494
Content-Type: text/plain; charset=us-ascii

I have been using nilfs as my rootfs for several weeks now and have been experiencing random problems.  X programs will be become unresponsive and top will show that segctord is using ~50%hi (100% of one core).

I get thousands of traces in my syslog.  Below is a sample:

Aug 11 17:00:59 gentoo klogd: BUG: scheduling while atomic: segctord/1312/0xffffffff
Aug 11 17:00:59 gentoo klogd: Modules linked in:
Aug 11 17:00:59 gentoo klogd: Pid: 1312, comm: segctord Not tainted 2.6.31-rc5-git7 #1
Aug 11 17:00:59 gentoo klogd: Call Trace:
Aug 11 17:00:59 gentoo klogd:  [<ffffffff813c9821>] ? thread_return+0x4af/0x6ee
Aug 11 17:00:59 gentoo klogd:  [<ffffffff8116245c>] ? __make_request+0x15c/0x3e0
Aug 11 17:00:59 gentoo klogd:  [<ffffffff813c9e05>] ? schedule_timeout+0x1a5/0x1e0
Aug 11 17:00:59 gentoo klogd:  [<ffffffff810b638b>] ? bvec_alloc_bs+0x5b/0x100
Aug 11 17:00:59 gentoo klogd:  [<ffffffff813c9071>] ? wait_for_common+0xc1/0x180
Aug 11 17:00:59 gentoo klogd:  [<ffffffff8102b5c0>] ? default_wake_function+0x0/0x20
Aug 11 17:00:59 gentoo klogd:  [<ffffffff8113f190>] ? nilfs_segbuf_wait+0x30/0x80
Aug 11 17:00:59 gentoo klogd:  [<ffffffff81142ef5>] ? nilfs_segctor_do_construct+0xf15/0x1ad0
Aug 11 17:00:59 gentoo klogd:  [<ffffffff81143dac>] ? nilfs_segctor_construct+0xbc/0xd0
Aug 11 17:00:59 gentoo klogd:  [<ffffffff8114413b>] ? nilfs_segctor_thread+0x15b/0x350
Aug 11 17:00:59 gentoo klogd:  [<ffffffff81140760>] ? nilfs_construction_timeout+0x0/0x10
Aug 11 17:00:59 gentoo klogd:  [<ffffffff810276d0>] ? __wake_up_common+0x50/0x80
Aug 11 17:00:59 gentoo klogd:  [<ffffffff810481d0>] ? autoremove_wake_function+0x0/0x30
Aug 11 17:00:59 gentoo klogd:  [<ffffffff81143fe0>] ? nilfs_segctor_thread+0x0/0x350
Aug 11 17:00:59 gentoo klogd:  [<ffffffff81047e56>] ? kthread+0x96/0xa0
Aug 11 17:00:59 gentoo klogd:  [<ffffffff8100c38a>] ? child_rip+0xa/0x20
Aug 11 17:00:59 gentoo klogd:  [<ffffffff81047dc0>] ? kthread+0x0/0xa0
Aug 11 17:00:59 gentoo klogd:  [<ffffffff8100c380>] ? child_rip+0x0/0x20
Aug 11 17:00:59 gentoo klogd: BUG: scheduling while atomic: segctord/1312/0xffffffff
Aug 11 17:00:59 gentoo klogd: Modules linked in:
Aug 11 17:00:59 gentoo klogd: Pid: 1312, comm: segctord Not tainted 2.6.31-rc5-git7 #1
Aug 11 17:00:59 gentoo klogd: Call Trace:
Aug 11 17:00:59 gentoo klogd:  [<ffffffff813c9821>] ? thread_return+0x4af/0x6ee
Aug 11 17:00:59 gentoo klogd:  [<ffffffff8116f368>] ? __up_write+0x98/0x140
Aug 11 17:00:59 gentoo klogd:  [<ffffffff8114431c>] ? nilfs_segctor_thread+0x33c/0x350
Aug 11 17:00:59 gentoo klogd:  [<ffffffff81140760>] ? nilfs_construction_timeout+0x0/0x10
Aug 11 17:00:59 gentoo klogd:  [<ffffffff810276d0>] ? __wake_up_common+0x50/0x80
Aug 11 17:00:59 gentoo klogd:  [<ffffffff810481d0>] ? autoremove_wake_function+0x0/0x30
Aug 11 17:00:59 gentoo klogd:  [<ffffffff81143fe0>] ? nilfs_segctor_thread+0x0/0x350
Aug 11 17:00:59 gentoo klogd:  [<ffffffff81047e56>] ? kthread+0x96/0xa0
Aug 11 17:00:59 gentoo klogd:  [<ffffffff8100c38a>] ? child_rip+0xa/0x20
Aug 11 17:00:59 gentoo klogd:  [<ffffffff81047dc0>] ? kthread+0x0/0xa0
Aug 11 17:00:59 gentoo klogd:  [<ffffffff8100c380>] ? child_rip+0x0/0x20


      
--0-187015945-1250028419=:6494
Content-Type: text/html; charset=us-ascii

<html><head><style type="text/css"><!-- DIV {margin:0px;} --></style></head><body><div style="font-family:times new roman,new york,times,serif;font-size:12pt"><div>I have been using nilfs as my rootfs for several weeks now and have been experiencing random problems.&nbsp; X programs will be become unresponsive and top will show that segctord is using ~50%hi (100% of one core).<br><br>I get thousands of traces in my syslog.&nbsp; Below is a sample:<br><br>Aug 11 17:00:59 gentoo klogd: BUG: scheduling while atomic: segctord/1312/0xffffffff<br>Aug 11 17:00:59 gentoo klogd: Modules linked in:<br>Aug 11 17:00:59 gentoo klogd: Pid: 1312, comm: segctord Not tainted 2.6.31-rc5-git7 #1<br>Aug 11 17:00:59 gentoo klogd: Call Trace:<br>Aug 11 17:00:59 gentoo klogd:&nbsp; [&lt;ffffffff813c9821&gt;] ? t
 hread_return+0x4af/0x6ee<br>Aug 11 17:00:59 gentoo klogd:&nbsp; [&lt;ffffffff8116245c&gt;] ? __make_request+0x15c/0x3e0<br>Aug 11 17:00:59 gentoo klogd:&nbsp;
 [&lt;ffffffff813c9e05&gt;] ? schedule_timeout+0x1a5/0x1e0<br>Aug 11 17:00:59 gentoo klogd:&nbsp; [&lt;ffffffff810b638b&gt;] ? bvec_alloc_bs+0x5b/0x100<br>Aug 11 17:00:59 gentoo klogd:&nbsp; [&lt;ffffffff813c9071&gt;] ? wait_for_common+0xc1/0x180<br>Aug 11 17:00:59 gentoo klogd:&nbsp; [&lt;ffffffff8102b5c0&gt;] ? default_wake_function+0x0/0x20<br>Aug 11 17:00:59 gentoo klogd:&nbsp; [&lt;ffffffff8113f190&gt;] ? nilfs_segbuf_wait+0x30/0x80<br>Aug 11 17:00:59 gentoo klogd:&nbsp; [&lt;ffffffff81142ef5&gt;] ? nilfs_segctor_do_construct+0xf15/0x1ad0<br>Aug 11 17:00:59 gentoo klogd:&nbsp; [&lt;ffffffff81143dac&gt;] ? nilfs_segctor_construct+0xbc/0xd0<br>Aug 11 17:00:59 gentoo klogd:&nbsp; [&lt;ffffffff8114413b&gt;] ? nilfs_segctor_thread+0x15b/0x350<br>Aug 11 17:00:59 gentoo klogd:&nbsp; [&lt;fff
 fffff81140760&gt;] ? nilfs_construction_timeout+0x0/0x10<br>Aug 11 17:00:59 gentoo klogd:&nbsp; [&lt;ffffffff810276d0&gt;] ? __wake_up_common+0x50/0x80<br>Aug 11
 17:00:59 gentoo klogd:&nbsp; [&lt;ffffffff810481d0&gt;] ? autoremove_wake_function+0x0/0x30<br>Aug 11 17:00:59 gentoo klogd:&nbsp; [&lt;ffffffff81143fe0&gt;] ? nilfs_segctor_thread+0x0/0x350<br>Aug 11 17:00:59 gentoo klogd:&nbsp; [&lt;ffffffff81047e56&gt;] ? kthread+0x96/0xa0<br>Aug 11 17:00:59 gentoo klogd:&nbsp; [&lt;ffffffff8100c38a&gt;] ? child_rip+0xa/0x20<br>Aug 11 17:00:59 gentoo klogd:&nbsp; [&lt;ffffffff81047dc0&gt;] ? kthread+0x0/0xa0<br>Aug 11 17:00:59 gentoo klogd:&nbsp; [&lt;ffffffff8100c380&gt;] ? child_rip+0x0/0x20<br>Aug 11 17:00:59 gentoo klogd: BUG: scheduling while atomic: segctord/1312/0xffffffff<br>Aug 11 17:00:59 gentoo klogd: Modules linked in:<br>Aug 11 17:00:59 gentoo klogd: Pid: 1312, comm: segctord Not tainted 2.6.31-rc5-git7 #1<br>Aug 11 17:00:59 gentoo klogd: 
 Call Trace:<br>Aug 11 17:00:59 gentoo klogd:&nbsp; [&lt;ffffffff813c9821&gt;] ? thread_return+0x4af/0x6ee<br>Aug 11 17:00:59 gentoo klogd:&nbsp;
 [&lt;ffffffff8116f368&gt;] ? __up_write+0x98/0x140<br>Aug 11 17:00:59 gentoo klogd:&nbsp; [&lt;ffffffff8114431c&gt;] ? nilfs_segctor_thread+0x33c/0x350<br>Aug 11 17:00:59 gentoo klogd:&nbsp; [&lt;ffffffff81140760&gt;] ? nilfs_construction_timeout+0x0/0x10<br>Aug 11 17:00:59 gentoo klogd:&nbsp; [&lt;ffffffff810276d0&gt;] ? __wake_up_common+0x50/0x80<br>Aug 11 17:00:59 gentoo klogd:&nbsp; [&lt;ffffffff810481d0&gt;] ? autoremove_wake_function+0x0/0x30<br>Aug 11 17:00:59 gentoo klogd:&nbsp; [&lt;ffffffff81143fe0&gt;] ? nilfs_segctor_thread+0x0/0x350<br>Aug 11 17:00:59 gentoo klogd:&nbsp; [&lt;ffffffff81047e56&gt;] ? kthread+0x96/0xa0<br>Aug 11 17:00:59 gentoo klogd:&nbsp; [&lt;ffffffff8100c38a&gt;] ? child_rip+0xa/0x20<br>Aug 11 17:00:59 gentoo klogd:&nbsp; [&lt;ffffffff81047dc0&gt;] ? kthrea
 d+0x0/0xa0<br>Aug 11 17:00:59 gentoo klogd:&nbsp; [&lt;ffffffff8100c380&gt;] ? child_rip+0x0/0x20<br><br></div></div><br>



      </body></html>
--0-187015945-1250028419=:6494--


--===============0228946958==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
users mailing list
users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
https://www.nilfs.org/mailman/listinfo/users

--===============0228946958==--

