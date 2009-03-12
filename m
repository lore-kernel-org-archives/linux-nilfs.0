From: Reinoud Zandijk <reinoud-S783fYmB3Ccdnm+yROfE0A@public.gmane.org>
Subject: Re: Dump tools for checkpoints
Date: Thu, 12 Mar 2009 16:26:18 +0100
Message-ID: <20090312152618.GA25317@aardappel.13thmonkey.org>
References: <2883.84.133.202.72.1235869032.squirrel@ssl.its-beck.de>
	<20090308.143916.113539820.ryusuke@osrg.net>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20090308.143916.113539820.ryusuke-sG5X7nlA6pw@public.gmane.org>
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
Cc: nilfs-MZZvbRqs/9F0RdzJJlgK+g@public.gmane.org

Dear Ryusuke, dear Pierre,

On Sun, Mar 08, 2009 at 02:39:16PM +0900, Ryusuke Konishi wrote:
> Actually I want to realize this feature in some form, and had
> considered details several times.  What I want to realize is
> checkpoint based replication including incremental dumping and
> restoration of file system states.

depends on the granlarity of the backup; do you want backup time backups or
checkpoint/snapshot based?

The first could be implemented (though not watertight) by comparing the DAT
files between checkpoint P and Q at backup time. If while parsing the filetree
at Q a change is noticed in the DAT allocation of the vblock the file is
changed.

The 2nd is easier and more logical; a snapshot is marked as the last backup
time. Then when the backup is updated, the checkpoints are walked and -just
like the cleaner- the diff is cleaned up between this snapshot and the next
backup snapshot. After the backup the old backup snapshot is either deleted or
is unmarked for backup. This way the backup granularity can be controlled by
the user in the time between backup snapshots.

just an idea, possible? problems?

With regards,
Reinoud
