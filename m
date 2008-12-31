From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: Re: Kernel Bug after corrupted filesystem
Date: Wed, 31 Dec 2008 11:53:54 +0900 (JST)
Message-ID: <20081231.115354.105606600.ryusuke@osrg.net>
References: <20081230131953.298540@gmx.net>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <20081230131953.298540-hi6Y0CQ0nG0@public.gmane.org>
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
To: users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org, robinx99-hi6Y0CQ0nG0@public.gmane.org

Hi,
On Tue, 30 Dec 2008 14:19:53 +0100, robinx99-hi6Y0CQ0nG0@public.gmane.org wrote:
> Hi,
> I am experimenting with nilfs2 for a while now, because I like the
> Idea of this filesystem. The filesystem I have problems with now is
> a more complex problem. I used just for testing purpose a file on an
> ext3 filesystem as a cryptoloop device and I used nilfs2 on the
> loopback device. It worked for about half a year without a
> problem. But I have no Idea what was actualy going wrong (ext3
> problem, cryptoloop problem, nilfs problem?) and I don't know if a
> filesystem under normal conditations get corrupted like this
> (actualy no real data loss either, because almost all files existed
> elswhere)
> But when I now try to mount the nilfs2 filesystem it does not
> work. No result from the mount command, but the attached in
> dmsg. 

Thank you for reporting the problem.
Again, it seems that a btree corruption happened.
Sorry, but it's hard to track the cause directly from the stack dump.

According to the log, the write barrier is disabled (it may be a
restriction of cryptoloop).  If you met an unexpected system down
before mounting nilfs, please let me know.

>The system is still useable, but I am not able to shut it down (have
>to hold power button 3 seconds). And I am not able to unload the
>nilfs module either (is in use) Hope this helps to further improve
>nilfs2.  robinx99

I've modified btree lookup routines to avoid system freeze and allow
clean termination; I pushed it to our git repository.

Regards,
Ryusuke
