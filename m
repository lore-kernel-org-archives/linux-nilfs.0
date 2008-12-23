From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: Re: Some nilfs comments
Date: Wed, 24 Dec 2008 02:23:37 +0900 (JST)
Message-ID: <20081224.022337.30445207.ryusuke@osrg.net>
References: <1229568775.27170.134.camel@think.oraclecorp.com>
	<20081222.180719.88488712.ryusuke@osrg.net>
	<20081222130152.GA23725@aardappel.13thmonkey.org>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <20081222130152.GA23725-5cYspOl2ggRz6xQTk39kMVfVdRo2wo/d@public.gmane.org>
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
To: users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org, reinoud-S783fYmB3Ccdnm+yROfE0A@public.gmane.org
Cc: chris.mason-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org

Hi Reinoud,
On Mon, 22 Dec 2008 14:01:52 +0100, Reinoud Zandijk <reinoud-S783fYmB3Ccdnm+yROfE0A@public.gmane.org> wrote:
> On Mon, Dec 22, 2008 at 06:07:19PM +0900, Ryusuke Konishi wrote:
> > Well, I feel that the following two matters are particularlly
> > questionable and need to be checked:
> > 
> > - struct the_nilfs:
> >   NILFS allows users to mount snapshots without making additional
> >   devices or volumes.  This is achieved by sharing a block device
> >   among multiple mount instances (i.e. super_block structs).
> >   the_nilfs struct is used for this sharing.
> > 
> >   This approach seems to be peculiar to nilfs, and I feel it needs
> >   attention.
> 
> I've dug into this too and decided to use the same mechanism for my
> implementation. I think its nice to have all the fs's administration centered
> at one place; i even have all the btree stuff there. One thing indeed is that
> its not possible to do say `unmount /dev/wd0a' if there are multiple mounts on
> it... but maybe thats better even ;) or its even a positive thing to just
> unmount all the mounts in one go.

I don't know the mount/umount interface of NetBSD, but perhaps unmount
system call takes a directory argument instead of a device.
If so, your kernel code would become similar to our nilfs.

Though the linux umount command can take a device argument, only the
latest mount is detached ;)

> > Thanks, I've also started to read btrfs.
> > I'll see it during the Christmas holidays  ;)
> 
> Whats your first impression? Want to take over things/ideas? Isn't that a
> quite different FS structurally since it doesn't have segments? (AFAIK!)

Yeah, btrfs has flexible and rich volume management layer, so very
interesting.  The snapshot code and c-tree also look like fun.

Regards,
Ryusuke
