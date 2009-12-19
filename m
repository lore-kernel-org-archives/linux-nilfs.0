From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: Re: Performance problems over AoE
Date: Sat, 19 Dec 2009 18:43:46 +0900 (JST)
Message-ID: <20091219.184346.239007912.ryusuke@osrg.net>
References: <200912190224.46774.krustev@krustev.net>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <200912190224.46774.krustev-sueGvCUcFGXR7s880joybQ@public.gmane.org>
List-Id: <linux-nilfs.vger.kernel.org>
List-Unsubscribe: <https://www.nilfs.org/mailman/options/users>,
	<mailto:users-request-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org?subject=unsubscribe>
List-Archive: <https://www.nilfs.org/pipermail/users>
List-Post: <mailto:users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
List-Help: <mailto:users-request-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org?subject=help>
List-Subscribe: <https://www.nilfs.org/mailman/listinfo/users>,
	<mailto:users-request-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org?subject=subscribe>
Sender: users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
Errors-To: users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
To: users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org, krustev-sueGvCUcFGXR7s880joybQ@public.gmane.org
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi!
On Sat, 19 Dec 2009 02:24:44 +0200, Delian Krustev <krustev-sueGvCUcFGXR7s880joybQ@public.gmane.org> wrote:
> 
> 	Hi All,
> 
> Nice to meet you :-)
> 
> I'm having performance problems with NILFS2 running on
> AoE (Ata over Ethernet) device.
> 
> I'm able to get around 5/10 MB sequential write speed for over a device
> which is capable of 100MB/s.
> 
> I've described the problem and my setup in details on a web page:
> 
> http://krustev.net/w/articles/Backup_service_and_software_block_devices_over_the_net/
> 
> 
> and will be thankful if you take a look and give some ideas.

Thank you for letting us know the interesting measurement result.

Actually we recognize similar issue on high performance drives, but
this looks worse than the cases we know.

In the 2.6.33 merge window, I sent some series of patches upstream to
improve write performance.  And, the effort is still going on.

I would appreciate it if you could try nilfs in kernel 2.6.33-rc1 or
optimization patches that will be appeared ongoingly in this list or
linux-nilfs.

> And one other question.
> Is there a way to disable the auto check point creation ?

Unfortunately no.  The contiguous check point creation is what nilfs
stands for.  But, I think the performance impact of cp creation is not
so high unless you are doing osync writes.
 
> Cheers
> --
> Delian

Cheers,
Ryusuke Konishi
