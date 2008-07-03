From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: Re: Mount memory allocation error
Date: Thu, 03 Jul 2008 20:30:27 +0900 (JST)
Message-ID: <20080703.203027.100419265.ryusuke@osrg.net>
References: <474dca090807030319w7ff440b0w1315c60fb7d56756@mail.gmail.com>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <474dca090807030319w7ff440b0w1315c60fb7d56756-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
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
To: users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org

Hi Peter,

On Thu, 3 Jul 2008 12:19:53 +0200, "Peter Smith" wrote:
> Hi,
> I recently upgraded my memory from 2G to 4G and this made it necessary to
> change my kernel
> from
> 2.6.22.5-31-default
> to
> 2.6.22.5-31-bigsmp
> 
> Now I cannot mount nilfs2 partitions.
> I get the error message:  mount.nilf2: ... ... Cannot allocate memory
> 
> My environment is
> OpenSuse 10.3
> nilfs 2.02
> nilfs-utils 2.04
> 
> Yes, I did recompile/install nilfs and nilfs-utils while using the bigsmp
> kernel.
> When I switch back to the default kernel mount.nilfs2 works normally,
> as does everything else.(but of course I don't have access to the full 4G
> memory)
> 
> Your help would be greatly appreciated
> Peter

Thank you for reporting this.
We are now trying to catch the problem.

BTW, did you try our binary package for OpenSuse?
It is available on http://www.nilfs.org/pub/opensuse/.

Does it incur the same problem?

Cheers,
Ryusuke Konishi
