From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: Re: Some nilfs comments
Date: Mon, 22 Dec 2008 18:07:19 +0900 (JST)
Message-ID: <20081222.180719.88488712.ryusuke@osrg.net>
References: <1229568775.27170.134.camel@think.oraclecorp.com>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <1229568775.27170.134.camel-cGoWVVl3WGUrkklhUoBCrlaTQe2KTcn/@public.gmane.org>
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
To: users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org, chris.mason-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org

Hi Chris,

On Wed, 17 Dec 2008 21:52:55 -0500, Chris Mason wrote:
> Hello,
> 
> I've been meaning to read through nilfs for a while, and I grabbed the
> code today to take a look.  The code is very clean and it ran well out
> of the box here.

Thank you very much for helpful comments!

> One problem I hit early on was that nilfs doesn't seem to zero out the
> block device during mkfs.  So after mkfs.nilfs2, mount still found my
> old btrfs filesystem.  It would be a good idea to zero out the first and
> last 1MB on the device (except for the first sector which might have the
> partition table).

Okay, I'll take this idea in mkfs.nilfs2.

> I haven't dug too deeply in yet, but if there are parts you're most
> interested in comments on, please let me know.

Well, I feel that the following two matters are particularlly
questionable and need to be checked:

- struct the_nilfs:
  NILFS allows users to mount snapshots without making additional
  devices or volumes.  This is achieved by sharing a block device
  among multiple mount instances (i.e. super_block structs).
  the_nilfs struct is used for this sharing.

  This approach seems to be peculiar to nilfs, and I feel it needs
  attention.

- ioctl:
  Ioctl interface (routines and structures) were implemented in an
  own way.  These seems to be checked whether to comply with the rules
  of ioctl design.


> It looks like nilfs_writepage ignores WB_SYNC_NONE, which is used by
> do_sync_mapping_range().

Thanks!  I didn't notice that this function was added.
Uum, it seems to require reconsidering the way to initiate writing of
data pages.

> nilfs_page_mkwrite doesn't seem to dirty the page?  block_page_mkwrite
> does more, including checks against i_size and others.

I got it.  The design of this function seems so old.  It should be
revised to do checks and block allocations previously at this
function.
 
> readpages and O_DIRECT both set b_size on the map_bh to reflect the
> total size of the region they are trying to map.  It seems like an easy
> optimization to map more in nilfs_get_block.

Yes, that's so true!

Actually, I have unfinished patches to do this.  This would decrease
the numbers of get_block callbacks and b-tree lookups.  And, as you
pointed out, this seems one of the easiest optimization in some todos
on performance.
 
> Hopefully this helps, I'll try to send a few more ideas after I get to
> know the code better.
> 
> -chris

Thanks, I've also started to read btrfs.
I'll see it during the Christmas holidays  ;)

With regards,
Ryusuke Konishi
