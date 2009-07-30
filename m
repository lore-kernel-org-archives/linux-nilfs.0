From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: Re: Number of CheckPoints
Date: Thu, 30 Jul 2009 23:52:14 +0900 (JST)
Message-ID: <20090730.235214.104764541.ryusuke@osrg.net>
References: <4A711C80.1040500@epoch.com>
	<20090730.233849.87826385.ryusuke@osrg.net>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <20090730.233849.87826385.ryusuke-sG5X7nlA6pw@public.gmane.org>
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
To: users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org, dfuller-ZE272gM1l1AAvxtiuMwx3w@public.gmane.org

On Thu, 30 Jul 2009 23:38:49 +0900 (JST), Ryusuke Konishi wrote:
> For example, a 32-bit Linux kernel can handle up to 2 ^ 32 blocks.
> Since NILFS2 stores 21 checkpoints in a standard 4KB block, 32-bit
> nilfs can handle up to
> 
>   90,194,313,215 (= about 90.2 giga) checkpoints
> 
> If we create a checkpoint per 5 seconds, it corresponds to
> 
>   18,038,862,643 seconds = 5,010,795 days = 13,728 years
> 
> So the conclusion is, you know, up to the capacity of your drive ;)

I made a miscalculation.

90,194,313,215 checkpoints = 

 450,971,566,080 seconds = 125,269,879 days = 343,205 years.

In either case, the conclustion is the same.

Ryusuke
