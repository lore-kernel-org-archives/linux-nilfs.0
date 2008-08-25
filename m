From: Reinoud Zandijk <reinoud-S783fYmB3Ccdnm+yROfE0A@public.gmane.org>
Subject: Re: directory entries
Date: Mon, 25 Aug 2008 17:52:44 +0200
Message-ID: <20080825155243.GA12855@aardappel.13thmonkey.org>
References: <20080823203853.GA19421@aardappel.13thmonkey.org>
	<20080825.122125.65657043.ryusuke@osrg.net>
	<20080825.123047.128885778.ryusuke@osrg.net>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20080825.123047.128885778.ryusuke-sG5X7nlA6pw@public.gmane.org>
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

Dear folks,

on the nilfs TODO list i find:

- writable snapshots

This sounds like a fun feature. Would you like to have 1) multiple writable 
and snapshotable heads? 2) support updating a snapshot or 3) support 
writing to a snapshot that is lost when unmounted? But how to number 
checkpoints and snapshots then?

- data integrity support

Isn't that already there ? I thought that each block had a CRC? or would 
you like to integrate that into the inode's btree?

- B tree base directory management
- Extent support

Isn't that mutually exclusive? I.e. btree's and extent support? Or are you 
refering to recording extents in a btree; i.e. map block 0->X, 1->X+1, 
2->X+2 to a form of block 0-15 to block X to X+15?

With regards,
Reinoud
