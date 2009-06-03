From: "Yongkun Wang" <yongkun-b/Nwfc8pyCekRP3n4FtbsiGn5s73+xxf@public.gmane.org>
Subject: Re: [SPAM] Set the protection period to zero
Date: Thu, 4 Jun 2009 01:42:02 +0900
Message-ID: <00c501c9e46a$38849890$a98dc9b0$@iis.u-tokyo.ac.jp>
References: <007501c9e34f$fad3b5f0$f07b21d0$@iis.u-tokyo.ac.jp>
	<20090602.210552.76002031.ryusuke@osrg.net>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <20090602.210552.76002031.ryusuke-sG5X7nlA6pw@public.gmane.org>
Content-Language: en-us
List-Id: <linux-nilfs.vger.kernel.org>
List-Unsubscribe: <https://www.nilfs.org/mailman/listinfo/users>,
	<mailto:users-request-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org?subject=unsubscribe>
List-Archive: <https://www.nilfs.org/pipermail/users>
List-Post: <mailto:users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
List-Help: <mailto:users-request-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org?subject=help>
List-Subscribe: <https://www.nilfs.org/mailman/listinfo/users>,
	<mailto:users-request-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org?subject=subscribe>
Sender: users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
Errors-To: users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
To: 'Ryusuke Konishi' <ryusuke-sG5X7nlA6pw@public.gmane.org>, users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org

Dear Ryusuke:

Thank you for the quick support. Nilfs2 is awesome.

It seems there is still overhead on the checkpoints. But if I set the protection period to 0, each time the cleanerd is invoked, it should clean all the obsolete data blocks. Is what I say right?
 
Thanks again.

Best regards,
Yongkun

-----Original Message-----
From: Ryusuke Konishi [mailto:ryusuke-sG5X7nlA6pw@public.gmane.org] 
Sent: Tuesday, June 02, 2009 9:06 PM
To: users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org; yongkun-b/Nwfc8pyCekRP3n4FtbsiGn5s73+xxf@public.gmane.org
Subject: Re: [NILFS users] [SPAM] Set the protection period to zero

Hi,
On Tue, 2 Jun 2009 16:01:40 +0900, "Yongkun Wang" wrote:
> Hey guys,
> 
> I want to set the protection period to zero, to disable the snapshot
> or checkpoint.  What I want is a simple log-structured file
> system. The GC can clean the obsolete blocks by interval only.
> 
> Is that possible?

I don't think it's achieved just by setting protection period to zero,
but it's possible by rewriting a few functions in cleanerd.c.

Of course, it's not exactly the same because nilfs kernel codes still
performs additional work needed to create checkpoints.

But, does it have a point for you?


Regards,
Ryusuke Konishi
