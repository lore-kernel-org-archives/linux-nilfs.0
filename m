From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: Re: some notes on a memory leak
Date: Fri, 15 Feb 2008 12:18:13 +0900
Message-ID: <1203045493.3198.111.camel@localhost.localdomain>
References: <20080214010258.76494d68@vosztok>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <20080214010258.76494d68@vosztok>
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
Content-Type: text/plain; charset="iso-8859-1"
To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>

Hi G=E1bor,

On Wed, 2008-02-13 at 15:40 +0100, Gergely G=E1bor wrote:
> This release works flawlessly for me, for over 4 hours now. No memory
> leak, no deadlock occured, as I tested the previously malfunctioning
> scenarios.

Good news!
We might finally see daylight for the stable release.

On Thu, 2008-02-14 at 01:02 +0100, Gergely G=E1bor wrote:
> I have left my computer working, testing nilfs. I have found that=20
> after a log period of time, most of the memory in the computer vas=20
> allocated as cache (according to vmstat) and even aftel killing all
>  processes that held files open, the amount (~430 megabytes) did not
>  decrease significantly. I have unmounted the filesystem, and most
>  cache was freed up, ...
>  This leads to the assumption, that some data is left cached, even=20
> when not in use. To reproduce this behaviour, I simply started=20
> "vmstat 1", and rtorrent, started a download, and watched the cache
>  consumption climb. after exiting rtorrent, most of the cache is not
> reclaimed, not even after a long period of time.=20

Yeah, this is the peculiar behaviour of Linux memory management.
Linux try to devote free memory to the page cache wherever possible.

> (i understand, that leaving blocks in the cache is preferable for
> a log structured fs, as that reduces seeks necessary for reading,
> but possibly some aging mechanism, and/or a maximum cache size
> option would be a good idea to implement in the future, if not yet done=
)

As I commented above, the bahaviour that leaves blocks in the cache,
is the nature of Linux, and basically its control is supposed to
be the matter of the Linux mm and applications.
For example, applications can invalidate the cache through
posix_fadvice() or madvise() system call, and users can tune
the cache behaviour through /sbin/sysctl vm.* or /proc/sys/vm/*.

Of course, we are taking full advantage of the nature for NILFS to
compensate the drawback that logfs incurs performance penalty=20
for reads.  And I believe that this cache behaviour is harmless=20
because most of cached pages are reclaimable any time if not modified.=20

However, a memory leak must be distinguished because it blows up
this scheme. I'm nervous about it if suspicious.
So, now I'm relieved to hear your report.

> Sorry for flooding the mail list with my self-contradictory status repo=
rts.

Don't mind. Your reports are very helpful.

> Please tell me, where can i read about the architecture of nilfs2=20
> in greater detail, other than the code? (i'm willing to understand=20
> the code as well, but i'd need some guidance, where to start.=20
> I'd be the most happy if i could provide some more useful help=20
> rather than constant "complaining") has many things changed since
>  nilfs1? (i have found papers about that on the project homepage)

One of my colleage is writing a paper of nilfs2, and I believe it
would satisify these requests.

Sincerely,
--=20
Ryusuke Konishi
NILFS team NTT
http://www.nilfs.org/
