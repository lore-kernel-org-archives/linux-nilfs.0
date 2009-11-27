From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: Re: [PATCHv2 0/9] nilfs2: reduce redundant
 mark_inode_dirty
Date: Fri, 27 Nov 2009 20:29:15 +0900 (JST)
Message-ID: <20091127.202915.25153572.ryusuke@osrg.net>
References: <1259318474-28342-1-git-send-email-jir@unicus.jp>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <1259318474-28342-1-git-send-email-jir-hfpbi5WX9J54Eiagz67IpQ@public.gmane.org>
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
To: users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org, jir-hfpbi5WX9J54Eiagz67IpQ@public.gmane.org
Cc: konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org

On Fri, 27 Nov 2009 19:41:05 +0900, Jiro SEKIBA <jir-hfpbi5WX9J54Eiagz67IpQ@public.gmane.org> wrote:
> Hi,
> 
> This is a revised series of patches to reduce redandunt mark_inode_dirty calls.
> 
> Many functions call mark_inode_dirty() whenever they change inode object.
> However, it is redundant to call mark_inode_dirty() to same inode object
> within a transaction.
> 
> Last patch also replaces all mark_inode_dirty() calls as
> nilfs_mark_inode_dirty(), to reduce deep function call tree.
> 
> Changes since v2 is:
> - deleted mark_inode_dirty(dir) in nilfs_mkdir()
> - moved mark_inod_dirty(dir) from nilfs_do_unlink() to nilfs_unlink()
> - correct diff stat ;-)
> 
>  fs/nilfs2/dir.c   |   24 ++++++---------
>  fs/nilfs2/inode.c |    7 ++--
>  fs/nilfs2/namei.c |   83 +++++++++++++++++++++++++++++++++-------------------
>  3 files changed, 66 insertions(+), 48 deletions(-)

Looks good to me. Applied on top of the for-next branch.

Thank you,
Ryusuke Konishi
