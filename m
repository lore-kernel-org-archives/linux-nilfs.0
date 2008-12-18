From: Chris Mason <chris.mason-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Some nilfs comments
Date: Wed, 17 Dec 2008 21:52:55 -0500
Message-ID: <1229568775.27170.134.camel@think.oraclecorp.com>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
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

Hello,

I've been meaning to read through nilfs for a while, and I grabbed the
code today to take a look.  The code is very clean and it ran well out
of the box here.

One problem I hit early on was that nilfs doesn't seem to zero out the
block device during mkfs.  So after mkfs.nilfs2, mount still found my
old btrfs filesystem.  It would be a good idea to zero out the first and
last 1MB on the device (except for the first sector which might have the
partition table).

I haven't dug too deeply in yet, but if there are parts you're most
interested in comments on, please let me know.

It looks like nilfs_writepage ignores WB_SYNC_NONE, which is used by
do_sync_mapping_range().

nilfs_page_mkwrite doesn't seem to dirty the page?  block_page_mkwrite
does more, including checks against i_size and others.

readpages and O_DIRECT both set b_size on the map_bh to reflect the
total size of the region they are trying to map.  It seems like an easy
optimization to map more in nilfs_get_block.

Hopefully this helps, I'll try to send a few more ideas after I get to
know the code better.

-chris
