From: Delian Krustev <krustev-sueGvCUcFGXR7s880joybQ@public.gmane.org>
Subject: Re: Performance problems over AoE
Date: Mon, 21 Dec 2009 18:21:39 +0200
Message-ID: <200912211821.45366.krustev@krustev.net>
References: <200912190224.46774.krustev@krustev.net>
	<20091219.184346.239007912.ryusuke@osrg.net>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <20091219.184346.239007912.ryusuke-sG5X7nlA6pw@public.gmane.org>
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
To: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org


	Hi,

Thanks for the answers.

On Sat, 19 Dec 2009 18:43:46 +0900 (JST) Ryusuke Konishi wrote:
> Thank you for letting us know the interesting measurement result.
> 
> Actually we recognize similar issue on high performance drives, but
> this looks worse than the cases we know.

This might be due to the increased latency of the AoE device.

> In the 2.6.33 merge window, I sent some series of patches upstream to
> improve write performance.  And, the effort is still going on.
> 
> I would appreciate it if you could try nilfs in kernel 2.6.33-rc1 or
> optimization patches that will be appeared ongoingly in this list or
> linux-nilfs.

OK, I will try it. Just have to figure out on which hardware since the
setup I've described is on production systems and running early RC kernels
there is not an option.
But I will probably find the metal or will create some VM images.

> Unfortunately no.  The contiguous check point creation is what nilfs
> stands for.  But, I think the performance impact of cp creation is not
> so high unless you are doing osync writes.

Did you read the part for the cleanerd causing high load on the network
interface ?
And the checkpoints being created with no data modifications ?

Do you have a guess for these ?


Cheers
--
Delian
