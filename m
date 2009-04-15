From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: Re: quering the nilfs2 garbage collection alg or schem
Date: Wed, 15 Apr 2009 23:55:46 +0900 (JST)
Message-ID: <20090415.235546.38389396.ryusuke@osrg.net>
References: <cda2f9040904142247u6e5b39e3o8bfe51d812281b13@mail.gmail.com>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <cda2f9040904142247u6e5b39e3o8bfe51d812281b13-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
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
To: users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org, justgn-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org

Hi,
On Wed, 15 Apr 2009 14:47:01 +0900, yong suk oh wrote:
> Dear nifls2 users and supporters
> 
> Hi
> 
> I have some question of garbage collection actually cleanerd
> 
> Could you provide an explanation of the cleanerd's(garbage collector)
> algorithm and method in
> cleaning the file system.
> 
> Plz let me know how is does work or some materials for me how it works
> 
> I looking for some document of nilfs2 development

Oh, sorry.

Yet, I cannot point to proper English materials especially for the
garbage collection. (sigh)

I recently added comments on each function in sbin/cleanerd/cleanerd.c
included in nilfs-utils package.  So, the recent package would be of
help.

Here, I'll try to explain how nilfs cleanerd works.

Please read nilfs2.txt file in nilfs2-module package if you are
unfamiliar with definition of term appearing here.

The cleanerd works as:

(1) Gets information of every segments from sufile (segment usage file)
    through ioctl, and selects reclaimable segments.

    The nilfs_suinfo struct stores the following information per segment:

     - sui_flags: indicate the segment is dirty, active, or erronous.
       the ``dirty'' flag shows in-use state, and the ``active'' flag
       shows the segment is used or reserved for writing so its
       unreclaimable.  The ``error'' flag shows the segment has once
       an I/O error.

     - sui_lastmod: the last modification time of the segment.
     - sui_nblocks: number of valid blocks in the segment.

     At this stage, segments which is dirty, non-active, and whose
     lastmod is older than protection period, are selected.

(2) Selects target segments by applying a specified selection policy.

    At present, it only supports ``timestamp'' policy which selects
    segments having older sui_lastmod.  The number of segments
    selected per cleaning is nsegments_per_clean parameter specified
    in /etc/nilfs_cleanerd.conf.

(3) Reads summary information of logs written in selected segments.

    struct nilfs_segment_summary in nilfs_fs.h (or nilfs2_fs.h) gives
    format of the header of the summary information.

    Finfo structures (nilfs_finfo) and binfo structures (nilfs_binfo)
    that follow the header, gives information on every block written
    in the log.

    Please refer to nilfs2.txt for organization of these structures
    and log.

(4) Judges whether each block in the log is dead or live.  The live
    blocks will be copied into a new log at (6), whereas dead blocks
    will be ignored and abandoned.

    Here, blocks are classified to two types:

    a) block pointed with a virtual block number (vbn for short).

       For this type of blocks, each block is judged as "dead" if and
       only if the block does not belong to any snapshots.  This is
       determined rather efficiently by checking lifetime information
       of vbn.

       Each vbn has a lifetime information on the corresponding entry
       in DAT file.  The DAT entry format is as follows:

       struct nilfs_dat_entry {
             __le64 de_blocknr;    /* disk block number */
             __le64 de_start;      /* start checkpoint number */
             __le64 de_end;        /* end checkpoint number */
             __le64 de_rsv;        /* reserved */
       };

       Roughly speaking, DAT is a table file of this entry each of
       which is indexed with a vbn.  In reality, the DAT file has more
       complex structure because the entries are divided into multiple
       groups and managed with a bitmap block in each group.

       So, the DAT file gives two relations

         1) vbn  ->  pbn                     i.e. actual block address
         2) vbn  ->  [start cno, end cno)    i.e. lifetime of the vbn

       Well, a vbn is judged as "live" if there is a snapshot whose
       checkpoint number is equal or greater than the "start cno" and
       smaller than the "end cno".

    b) block pointed with a actual block number (pbn for short).

       This type of block is judged with an usual GC dead or live
       algorithm; i.e. it is judged "live" if the block is referable
       directly or indirectly from inode of the file.

       The cleanerd calls nilfs_get_bdescs() ioctl to get pbn of block
       currently pointed for an file offset or a level and a key
       number in case of b-tree node blocks.  If the acquired pbn
       equals to the pbn of target block, then the block is "live".
       Otherwise it is "dead".

    The method (b) is only applied to DAT blocks.  Other files are
    judged with the method (a).

(5) Determines checkpoints which should be removed at cleaning.

    A checkpoint number must be removed if it was included in a
    lifetime period of a certain block judged as "dead".

    So, union of periods [start cno, end cno) judged as "dead", gives
    a set of checkpoint numbers to be deleted.

(6) Calls nilfs_clean_segment() ioctl for cleaning.

    nilfs_clean_segment() does the following jobs at a time.

    1) delete entries of cleaning segments from sufile.
    2) removes checkpoints selected in the step (5) from cpfile.
    3) removes dat entries of "dead" vbn from the DAT file, and
    4) reads blocks to be copied, and writes them into new logs with
       the updated meta data files.  This forms a new checkpoint.

(7) Sleeps for predetermined time and goes to the step (1).


In reality, we have to take account of "protection_period".  Please
see the source code of cleanerd to know how this affects.

If you have additional questions, I'll try to add in this mailing list
as possible as I can.

Regards,
Ryusuke Konishi
