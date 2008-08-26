From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: Re: directory entries
Date: Tue, 26 Aug 2008 19:29:42 +0900 (JST)
Message-ID: <20080826.192942.104752679.ryusuke@osrg.net>
References: <20080825.122125.65657043.ryusuke@osrg.net>
	<20080825.123047.128885778.ryusuke@osrg.net>
	<20080825155243.GA12855@aardappel.13thmonkey.org>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <20080825155243.GA12855-5cYspOl2ggRz6xQTk39kMVfVdRo2wo/d@public.gmane.org>
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

Hi,

On Mon, 25 Aug 2008 17:52:44 +0200, Reinoud Zandijk wrote:
> on the nilfs TODO list i find:
>
> - writable snapshots
> 
> This sounds like a fun feature. Would you like to have 1) multiple writable 
> and snapshotable heads? 2) support updating a snapshot or 3) support 
> writing to a snapshot that is lost when unmounted?

What's the difference between (1) and (2), do you mean ?
The number of read/write mounts concurrently mountable ?

I'd like to allow read/write mount for snapshots like:

  # mount -t nilfs2 -o rw,cp=xxx /dev/block /dir

and maybe (2) is nearest to what I want.
The (3) seems to be rather restrictive.

> But how to number checkpoints and snapshots then?

I don't like CVS revision like extension.
Just appending derived checkpoints (from a snapshot) to current head,
seems to be preferable.  What do you think?

> - data integrity support
> 
> Isn't that already there ? I thought that each block had a CRC? or would 
> you like to integrate that into the inode's btree?

No, each block doesn't have CRC.  Two CRCs are given to each log, one
for header and one for the whole log.  These are used for GC and mount
time recovery.  Neither are used for read time data verification.

These CRC cannot be referred to efficiently when reading data blocks
or B-tree node blocks because they are written in the header of logs.
It may be possible to use them in background task which gets hints
from read requests and verifies blocks.  Of course the ZFS like
extension is one way, but we don't have difinite plan for now.

I'd rather expect that the future data integrity extension of block
layer (e.g. T10 DIF) due to simplicity and performance reason.

> - B tree base directory management
> - Extent support
> 
> Isn't that mutually exclusive? I.e. btree's and extent support? Or are you 
> refering to recording extents in a btree; i.e. map block 0->X, 1->X+1, 
> 2->X+2 to a form of block 0-15 to block X to X+15?

Yeah, that's a bit ambiguous and inconsistent.
Think them separately, please.  These are the items in long term todo list.

For extent based management, there seem to be some possibilities to apply
it in NILFS.  For example,

- Extent tree (like ext4.  This is a possible displacement of B-tree )
- Extent based DAT (would save disk space consumed by DAT and improve
  performance)
- Extent based binfo in segment summary.

Among these, the second one seems to be worth of consideration IMO.
Anyhow, ``Extent support'' on the page should be rewritten.

Regards,
Ryusuke Konishi
