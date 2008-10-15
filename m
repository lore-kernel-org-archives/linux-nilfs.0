From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: Re: Snapshot and mount scripts
Date: Wed, 15 Oct 2008 23:23:56 +0900 (JST)
Message-ID: <20081015.232356.82122358.ryusuke@osrg.net>
References: <48F3C04B.7000300@mib-infotech.co.nz>
	<20081015.152427.73215105.ryusuke@osrg.net>
	<48F59E90.9060404@mib-infotech.co.nz>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <48F59E90.9060404-jE24nFfhqzU3hwNNidygWXTaI6DYlTYJ@public.gmane.org>
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
To: users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org, John-jE24nFfhqzU3hwNNidygWXTaI6DYlTYJ@public.gmane.org

Hi John,

On Wed, 15 Oct 2008 20:41:04 +1300, John Huttley wrote:
> Hi Ryusuke,
> 
> My point is that I don't actually care about cp's or snapshots.
> 
> They are a means to an end and not an end in themselves.

I agree with this.

Note, however, that the difference between cp's and snapshots is
fundamental for nilfs2 because it provides they are temporary or
persistent.  Users should at least understand this semantics.

> For the purpose of making a backup, if we can snapshot-and-mount, then 
> they can be anonymous.
> If they are anonymous, we don't have to worry about old snapshots 
> filling up the system. Unmount and they are gone.
> That covers the biggest use of snapshots-- making a consistent backup.
> 
> If you want to change a cp to a ss on mount, you still have to provide 
> the cp number, which is hard to script.

Actually, the primitive version of nilfs2 had a support of the
``anonymous'' snapshot mount but it was disabled before the first
formal release.

Users could mount snapshots just with a readonly option as follows:

 # mount -t nilfs2 /dev/sdb1 /nilfs
 ...
 # mount -t nilfs2 -r /dev/sdb1 /backup

And this was convenient for (consistent) online backup as you say.
Unfortunately, NILFSv2 cannot do this due to race problems of GC.
(It is possible on NILFS version 1, which does not have GC).

If you like this anonymous snapshot mount, I'll try to bring it back.

With regards,
Ryusuke Konishi
