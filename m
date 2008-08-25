From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: Re: directory entries
Date: Mon, 25 Aug 2008 12:21:25 +0900 (JST)
Message-ID: <20080825.122125.65657043.ryusuke@osrg.net>
References: <20080823203853.GA19421@aardappel.13thmonkey.org>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <20080823203853.GA19421-5cYspOl2ggRz6xQTk39kMVfVdRo2wo/d@public.gmane.org>
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

Hi, Reinoud!

On Sat, 23 Aug 2008 22:38:53 +0200, Reinoud Zandijk wrote:
> Dear folks,
> i wondered why directory lengths are specified in blocksize units resulting 
> in the last dirent in the block to fill up the space with its rec_len. 
> Searching for free space to enter a directory entry i could use 
> rec_len - NILFS_DIR_REC_LEN(last_dir_enty->namelen) as free space indicator 
> but i wondered if it might not be a better practice to allow zero-length 
> dir entries that are used to fill up the rest of the block with its 
> rec_len.
> 
> Thoughts?

The directory format of NILFS comes from that of ext2 file system
except its inode number field is extended to 64 bytes.  So, for
code maintenance, I think it's not good idea to make such change.

Redesigning directory format is actually one of todo items.
If someone send us a better alternative, we may switch to it.
In the meantime however, we'd like to avoid confusion on this.

Thank you for comments.

Regards,
Ryusuke Konishi
