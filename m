From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: Re: Snapshot and mount scripts
Date: Wed, 15 Oct 2008 15:24:27 +0900 (JST)
Message-ID: <20081015.152427.73215105.ryusuke@osrg.net>
References: <48F3C04B.7000300@mib-infotech.co.nz>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <48F3C04B.7000300-jE24nFfhqzU3hwNNidygWXTaI6DYlTYJ@public.gmane.org>
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

Hi,

On Tue, 14 Oct 2008 10:40:27 +1300, John Huttley wrote:
> Hi
> 
> I've just discovered nilfs, which is great for its snapshot capability.
>
> Since the purpose of having a snapshot is to mount it, I was surprised 
> that the utilities do not
> have a snapshot-and-mount  and  unmount-and-delete   ability.
> 
> Has anyone made a script to do this?

Thank you for your interest in NILFS.

How about making every checkpoint mountable ?
Does it differ from what you want?

It seems to be possible to enhance mount.nilfs2 and umount.nilfs2 to
allow changing given checkpoint to snapshot just before mounting, and
restoring the state on unmount. (This is not a polite way but
seems enough for most cases)

Regards,
Ryusuke
