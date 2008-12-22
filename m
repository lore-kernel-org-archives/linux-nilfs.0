From: Reinoud Zandijk <reinoud-S783fYmB3Ccdnm+yROfE0A@public.gmane.org>
Subject: Re: Some nilfs comments
Date: Mon, 22 Dec 2008 14:01:52 +0100
Message-ID: <20081222130152.GA23725@aardappel.13thmonkey.org>
References: <1229568775.27170.134.camel@think.oraclecorp.com>
	<20081222.180719.88488712.ryusuke@osrg.net>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20081222.180719.88488712.ryusuke-sG5X7nlA6pw@public.gmane.org>
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
To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Cc: chris.mason-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org

Hi Ryusuke, Chris,

On Mon, Dec 22, 2008 at 06:07:19PM +0900, Ryusuke Konishi wrote:
> Well, I feel that the following two matters are particularlly
> questionable and need to be checked:
> 
> - struct the_nilfs:
>   NILFS allows users to mount snapshots without making additional
>   devices or volumes.  This is achieved by sharing a block device
>   among multiple mount instances (i.e. super_block structs).
>   the_nilfs struct is used for this sharing.
> 
>   This approach seems to be peculiar to nilfs, and I feel it needs
>   attention.

I've dug into this too and decided to use the same mechanism for my
implementation. I think its nice to have all the fs's administration centered
at one place; i even have all the btree stuff there. One thing indeed is that
its not possible to do say `unmount /dev/wd0a' if there are multiple mounts on
it... but maybe thats better even ;) or its even a positive thing to just
unmount all the mounts in one go.

> - ioctl:
>   Ioctl interface (routines and structures) were implemented in an
>   own way.  These seems to be checked whether to comply with the rules
>   of ioctl design.

I can't comment on that yet since i haven't dug into that...

> Thanks, I've also started to read btrfs.
> I'll see it during the Christmas holidays  ;)

Whats your first impression? Want to take over things/ideas? Isn't that a
quite different FS structurally since it doesn't have segments? (AFAIK!)

With regards,
Reinoud Zandijk
