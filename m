From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Subject: [PATCH 03/11] nilfs2: remove FSF mailing address from GPL notices
Date: Fri, 29 Apr 2016 22:15:39 +0900
Message-ID: <1461935747-10380-4-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
References: <1461935747-10380-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :lines;
        bh=ugCtmO/nv39GowFo4qRl+bd5IUKV6XDvWeAwBoLcHGs=;
        b=MP+finPkbBMBGaSl31krWwXknPvdzZGGiukFnHp42HuXMQs3VtqlFrHhkE5gaDDIZA
         Wr3kciaT8C2tmvm6bwOjDVixwatvDmyNKrm4K4xCJGnSk7AypupDOuc//qJGLosxvfWE
         2aRdi9z179MDdUrFKSu6mou3amMboAUSdo7uG6WzHxjWned60/ACy1i93AbVCgQ1m8e2
         EuBBtxD/QF6Gdx/4kuj0mEtVgLqpHStqGl28NA19aVZDblaONncEgyyeH5QSoSG3tSqS
         MMMnS0erXDIqR3i5s12F2OYeQvibTGeLKpW5Nb7wTaSjo8FpPri6pZXihS6jqhJYuhlM
         S9+w==
In-Reply-To: <1461935747-10380-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-nilfs <linux-nilfs@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>

This removes the extra paragraph which mentions FSF address in GPL
notices from source code of nilfs2 and avoids the checkpatch.pl error
related to it.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
---
 fs/nilfs2/alloc.c         | 4 ----
 fs/nilfs2/alloc.h         | 4 ----
 fs/nilfs2/bmap.c          | 4 ----
 fs/nilfs2/bmap.h          | 4 ----
 fs/nilfs2/btnode.c        | 4 ----
 fs/nilfs2/btnode.h        | 4 ----
 fs/nilfs2/btree.c         | 4 ----
 fs/nilfs2/btree.h         | 4 ----
 fs/nilfs2/cpfile.c        | 4 ----
 fs/nilfs2/cpfile.h        | 4 ----
 fs/nilfs2/dat.c           | 4 ----
 fs/nilfs2/dat.h           | 4 ----
 fs/nilfs2/dir.c           | 4 ----
 fs/nilfs2/direct.c        | 4 ----
 fs/nilfs2/direct.h        | 4 ----
 fs/nilfs2/file.c          | 4 ----
 fs/nilfs2/gcinode.c       | 4 ----
 fs/nilfs2/ifile.c         | 4 ----
 fs/nilfs2/ifile.h         | 4 ----
 fs/nilfs2/inode.c         | 4 ----
 fs/nilfs2/ioctl.c         | 4 ----
 fs/nilfs2/mdt.c           | 4 ----
 fs/nilfs2/mdt.h           | 4 ----
 fs/nilfs2/namei.c         | 4 ----
 fs/nilfs2/nilfs.h         | 4 ----
 fs/nilfs2/page.c          | 4 ----
 fs/nilfs2/page.h          | 4 ----
 fs/nilfs2/recovery.c      | 4 ----
 fs/nilfs2/segbuf.c        | 4 ----
 fs/nilfs2/segbuf.h        | 4 ----
 fs/nilfs2/segment.c       | 4 ----
 fs/nilfs2/segment.h       | 4 ----
 fs/nilfs2/sufile.c        | 4 ----
 fs/nilfs2/sufile.h        | 4 ----
 fs/nilfs2/super.c         | 4 ----
 fs/nilfs2/the_nilfs.c     | 4 ----
 fs/nilfs2/the_nilfs.h     | 4 ----
 include/linux/nilfs2_fs.h | 4 ----
 38 files changed, 152 deletions(-)

diff --git a/fs/nilfs2/alloc.c b/fs/nilfs2/alloc.c
index 2ccbf55..eaa0c6a 100644
--- a/fs/nilfs2/alloc.c
+++ b/fs/nilfs2/alloc.c
@@ -13,10 +13,6 @@
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU General Public License for more details.
  *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
- *
  * Original code was written by Koji Sato <koji@osrg.net>.
  * Two allocators were unified by Ryusuke Konishi <ryusuke@osrg.net>,
  *                                Amagai Yoshiji <amagai@osrg.net>.
diff --git a/fs/nilfs2/alloc.h b/fs/nilfs2/alloc.h
index 6e6f49a..62982ee 100644
--- a/fs/nilfs2/alloc.h
+++ b/fs/nilfs2/alloc.h
@@ -13,10 +13,6 @@
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU General Public License for more details.
  *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
- *
  * Original code was written by Koji Sato <koji@osrg.net>.
  * Two allocators were unified by Ryusuke Konishi <ryusuke@osrg.net>,
  *                                Amagai Yoshiji <amagai@osrg.net>.
diff --git a/fs/nilfs2/bmap.c b/fs/nilfs2/bmap.c
index a9fb363..fcd79e6 100644
--- a/fs/nilfs2/bmap.c
+++ b/fs/nilfs2/bmap.c
@@ -13,10 +13,6 @@
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU General Public License for more details.
  *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
- *
  * Written by Koji Sato <koji@osrg.net>.
  */
 
diff --git a/fs/nilfs2/bmap.h b/fs/nilfs2/bmap.h
index bfa817c..baa6d40 100644
--- a/fs/nilfs2/bmap.h
+++ b/fs/nilfs2/bmap.h
@@ -13,10 +13,6 @@
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU General Public License for more details.
  *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
- *
  * Written by Koji Sato <koji@osrg.net>.
  */
 
diff --git a/fs/nilfs2/btnode.c b/fs/nilfs2/btnode.c
index e0c9daf..55241ef 100644
--- a/fs/nilfs2/btnode.c
+++ b/fs/nilfs2/btnode.c
@@ -13,10 +13,6 @@
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU General Public License for more details.
  *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
- *
  * This file was originally written by Seiji Kihara <kihara@osrg.net>
  * and fully revised by Ryusuke Konishi <ryusuke@osrg.net> for
  * stabilization and simplification.
diff --git a/fs/nilfs2/btnode.h b/fs/nilfs2/btnode.h
index d876b56..0727096 100644
--- a/fs/nilfs2/btnode.h
+++ b/fs/nilfs2/btnode.h
@@ -13,10 +13,6 @@
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU General Public License for more details.
  *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
- *
  * Written by Seiji Kihara <kihara@osrg.net>
  * Revised by Ryusuke Konishi <ryusuke@osrg.net>
  */
diff --git a/fs/nilfs2/btree.c b/fs/nilfs2/btree.c
index 3a3821b..cc748ff 100644
--- a/fs/nilfs2/btree.c
+++ b/fs/nilfs2/btree.c
@@ -13,10 +13,6 @@
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU General Public License for more details.
  *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
- *
  * Written by Koji Sato <koji@osrg.net>.
  */
 
diff --git a/fs/nilfs2/btree.h b/fs/nilfs2/btree.h
index 22c02e3..9497732 100644
--- a/fs/nilfs2/btree.h
+++ b/fs/nilfs2/btree.h
@@ -13,10 +13,6 @@
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU General Public License for more details.
  *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
- *
  * Written by Koji Sato <koji@osrg.net>.
  */
 
diff --git a/fs/nilfs2/cpfile.c b/fs/nilfs2/cpfile.c
index b6596ca..15016ec 100644
--- a/fs/nilfs2/cpfile.c
+++ b/fs/nilfs2/cpfile.c
@@ -13,10 +13,6 @@
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU General Public License for more details.
  *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
- *
  * Written by Koji Sato <koji@osrg.net>.
  */
 
diff --git a/fs/nilfs2/cpfile.h b/fs/nilfs2/cpfile.h
index a242b9a..3dcaceb 100644
--- a/fs/nilfs2/cpfile.h
+++ b/fs/nilfs2/cpfile.h
@@ -13,10 +13,6 @@
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU General Public License for more details.
  *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
- *
  * Written by Koji Sato <koji@osrg.net>.
  */
 
diff --git a/fs/nilfs2/dat.c b/fs/nilfs2/dat.c
index 7dc23f1..7427c11 100644
--- a/fs/nilfs2/dat.c
+++ b/fs/nilfs2/dat.c
@@ -13,10 +13,6 @@
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU General Public License for more details.
  *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
- *
  * Written by Koji Sato <koji@osrg.net>.
  */
 
diff --git a/fs/nilfs2/dat.h b/fs/nilfs2/dat.h
index cbd8e97..edd0586 100644
--- a/fs/nilfs2/dat.h
+++ b/fs/nilfs2/dat.h
@@ -13,10 +13,6 @@
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU General Public License for more details.
  *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
- *
  * Written by Koji Sato <koji@osrg.net>.
  */
 
diff --git a/fs/nilfs2/dir.c b/fs/nilfs2/dir.c
index e08f064..6817930 100644
--- a/fs/nilfs2/dir.c
+++ b/fs/nilfs2/dir.c
@@ -13,10 +13,6 @@
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU General Public License for more details.
  *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
- *
  * Modified for NILFS by Amagai Yoshiji <amagai@osrg.net>
  */
 /*
diff --git a/fs/nilfs2/direct.c b/fs/nilfs2/direct.c
index ebf89fd..2470022 100644
--- a/fs/nilfs2/direct.c
+++ b/fs/nilfs2/direct.c
@@ -13,10 +13,6 @@
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU General Public License for more details.
  *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
- *
  * Written by Koji Sato <koji@osrg.net>.
  */
 
diff --git a/fs/nilfs2/direct.h b/fs/nilfs2/direct.h
index dc643de..e4eb1b7 100644
--- a/fs/nilfs2/direct.h
+++ b/fs/nilfs2/direct.h
@@ -13,10 +13,6 @@
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU General Public License for more details.
  *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
- *
  * Written by Koji Sato <koji@osrg.net>.
  */
 
diff --git a/fs/nilfs2/file.c b/fs/nilfs2/file.c
index 088ba00..49243ca 100644
--- a/fs/nilfs2/file.c
+++ b/fs/nilfs2/file.c
@@ -13,10 +13,6 @@
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU General Public License for more details.
  *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
- *
  * Written by Amagai Yoshiji <amagai@osrg.net>,
  *            Ryusuke Konishi <ryusuke@osrg.net>
  */
diff --git a/fs/nilfs2/gcinode.c b/fs/nilfs2/gcinode.c
index 0224b78..b032188 100644
--- a/fs/nilfs2/gcinode.c
+++ b/fs/nilfs2/gcinode.c
@@ -13,10 +13,6 @@
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU General Public License for more details.
  *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
- *
  * Written by Seiji Kihara <kihara@osrg.net>, Amagai Yoshiji <amagai@osrg.net>,
  *            and Ryusuke Konishi <ryusuke@osrg.net>.
  * Revised by Ryusuke Konishi <ryusuke@osrg.net>.
diff --git a/fs/nilfs2/ifile.c b/fs/nilfs2/ifile.c
index 6548c78..06f9b5a 100644
--- a/fs/nilfs2/ifile.c
+++ b/fs/nilfs2/ifile.c
@@ -13,10 +13,6 @@
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU General Public License for more details.
  *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
- *
  * Written by Amagai Yoshiji <amagai@osrg.net>.
  * Revised by Ryusuke Konishi <ryusuke@osrg.net>.
  *
diff --git a/fs/nilfs2/ifile.h b/fs/nilfs2/ifile.h
index 679674d..c61637e 100644
--- a/fs/nilfs2/ifile.h
+++ b/fs/nilfs2/ifile.h
@@ -13,10 +13,6 @@
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU General Public License for more details.
  *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
- *
  * Written by Amagai Yoshiji <amagai@osrg.net>
  * Revised by Ryusuke Konishi <ryusuke@osrg.net>
  *
diff --git a/fs/nilfs2/inode.c b/fs/nilfs2/inode.c
index 5346313..4ef5c05 100644
--- a/fs/nilfs2/inode.c
+++ b/fs/nilfs2/inode.c
@@ -13,10 +13,6 @@
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU General Public License for more details.
  *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
- *
  * Written by Ryusuke Konishi <ryusuke@osrg.net>
  *
  */
diff --git a/fs/nilfs2/ioctl.c b/fs/nilfs2/ioctl.c
index e8fe248..4db0e5f 100644
--- a/fs/nilfs2/ioctl.c
+++ b/fs/nilfs2/ioctl.c
@@ -13,10 +13,6 @@
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU General Public License for more details.
  *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
- *
  * Written by Koji Sato <koji@osrg.net>.
  */
 
diff --git a/fs/nilfs2/mdt.c b/fs/nilfs2/mdt.c
index f6982b9..0ab93bd 100644
--- a/fs/nilfs2/mdt.c
+++ b/fs/nilfs2/mdt.c
@@ -13,10 +13,6 @@
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU General Public License for more details.
  *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
- *
  * Written by Ryusuke Konishi <ryusuke@osrg.net>
  */
 
diff --git a/fs/nilfs2/mdt.h b/fs/nilfs2/mdt.h
index 03246ca..5fc07ec 100644
--- a/fs/nilfs2/mdt.h
+++ b/fs/nilfs2/mdt.h
@@ -13,10 +13,6 @@
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU General Public License for more details.
  *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
- *
  * Written by Ryusuke Konishi <ryusuke@osrg.net>
  */
 
diff --git a/fs/nilfs2/namei.c b/fs/nilfs2/namei.c
index 151bc19..581e901 100644
--- a/fs/nilfs2/namei.c
+++ b/fs/nilfs2/namei.c
@@ -13,10 +13,6 @@
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU General Public License for more details.
  *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
- *
  * Modified for NILFS by Amagai Yoshiji <amagai@osrg.net>,
  *                       Ryusuke Konishi <ryusuke@osrg.net>
  */
diff --git a/fs/nilfs2/nilfs.h b/fs/nilfs2/nilfs.h
index 3857040..e2089a1 100644
--- a/fs/nilfs2/nilfs.h
+++ b/fs/nilfs2/nilfs.h
@@ -13,10 +13,6 @@
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU General Public License for more details.
  *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
- *
  * Written by Koji Sato <koji@osrg.net>
  *            Ryusuke Konishi <ryusuke@osrg.net>
  */
diff --git a/fs/nilfs2/page.c b/fs/nilfs2/page.c
index 4893915..b10057e 100644
--- a/fs/nilfs2/page.c
+++ b/fs/nilfs2/page.c
@@ -13,10 +13,6 @@
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU General Public License for more details.
  *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
- *
  * Written by Ryusuke Konishi <ryusuke@osrg.net>,
  *            Seiji Kihara <kihara@osrg.net>.
  */
diff --git a/fs/nilfs2/page.h b/fs/nilfs2/page.h
index a43b828..6df10e1 100644
--- a/fs/nilfs2/page.h
+++ b/fs/nilfs2/page.h
@@ -13,10 +13,6 @@
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU General Public License for more details.
  *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
- *
  * Written by Ryusuke Konishi <ryusuke@osrg.net>,
  *            Seiji Kihara <kihara@osrg.net>.
  */
diff --git a/fs/nilfs2/recovery.c b/fs/nilfs2/recovery.c
index 5afa77f..2ae1dfc 100644
--- a/fs/nilfs2/recovery.c
+++ b/fs/nilfs2/recovery.c
@@ -13,10 +13,6 @@
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU General Public License for more details.
  *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
- *
  * Written by Ryusuke Konishi <ryusuke@osrg.net>
  */
 
diff --git a/fs/nilfs2/segbuf.c b/fs/nilfs2/segbuf.c
index f63620c..8aef62d 100644
--- a/fs/nilfs2/segbuf.c
+++ b/fs/nilfs2/segbuf.c
@@ -13,10 +13,6 @@
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU General Public License for more details.
  *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
- *
  * Written by Ryusuke Konishi <ryusuke@osrg.net>
  *
  */
diff --git a/fs/nilfs2/segbuf.h b/fs/nilfs2/segbuf.h
index b04f08c..fa4ed03 100644
--- a/fs/nilfs2/segbuf.h
+++ b/fs/nilfs2/segbuf.h
@@ -13,10 +13,6 @@
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU General Public License for more details.
  *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
- *
  * Written by Ryusuke Konishi <ryusuke@osrg.net>
  *
  */
diff --git a/fs/nilfs2/segment.c b/fs/nilfs2/segment.c
index 483e663..cafb61c 100644
--- a/fs/nilfs2/segment.c
+++ b/fs/nilfs2/segment.c
@@ -13,10 +13,6 @@
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU General Public License for more details.
  *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
- *
  * Written by Ryusuke Konishi <ryusuke@osrg.net>
  *
  */
diff --git a/fs/nilfs2/segment.h b/fs/nilfs2/segment.h
index 0408b9b..a118eab 100644
--- a/fs/nilfs2/segment.h
+++ b/fs/nilfs2/segment.h
@@ -13,10 +13,6 @@
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU General Public License for more details.
  *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
- *
  * Written by Ryusuke Konishi <ryusuke@osrg.net>
  *
  */
diff --git a/fs/nilfs2/sufile.c b/fs/nilfs2/sufile.c
index 5b37204..1d60248 100644
--- a/fs/nilfs2/sufile.c
+++ b/fs/nilfs2/sufile.c
@@ -13,10 +13,6 @@
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU General Public License for more details.
  *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
- *
  * Written by Koji Sato <koji@osrg.net>.
  * Revised by Ryusuke Konishi <ryusuke@osrg.net>.
  */
diff --git a/fs/nilfs2/sufile.h b/fs/nilfs2/sufile.h
index 35e34c8..c4cf47e 100644
--- a/fs/nilfs2/sufile.h
+++ b/fs/nilfs2/sufile.h
@@ -13,10 +13,6 @@
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU General Public License for more details.
  *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
- *
  * Written by Koji Sato <koji@osrg.net>.
  */
 
diff --git a/fs/nilfs2/super.c b/fs/nilfs2/super.c
index e05d184..d304faa 100644
--- a/fs/nilfs2/super.c
+++ b/fs/nilfs2/super.c
@@ -13,10 +13,6 @@
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU General Public License for more details.
  *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
- *
  * Written by Ryusuke Konishi <ryusuke@osrg.net>
  */
 /*
diff --git a/fs/nilfs2/the_nilfs.c b/fs/nilfs2/the_nilfs.c
index 69bd801..8e27012 100644
--- a/fs/nilfs2/the_nilfs.c
+++ b/fs/nilfs2/the_nilfs.c
@@ -13,10 +13,6 @@
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU General Public License for more details.
  *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
- *
  * Written by Ryusuke Konishi <ryusuke@osrg.net>
  *
  */
diff --git a/fs/nilfs2/the_nilfs.h b/fs/nilfs2/the_nilfs.h
index 23778d3..426e4ac 100644
--- a/fs/nilfs2/the_nilfs.h
+++ b/fs/nilfs2/the_nilfs.h
@@ -13,10 +13,6 @@
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU General Public License for more details.
  *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
- *
  * Written by Ryusuke Konishi <ryusuke@osrg.net>
  *
  */
diff --git a/include/linux/nilfs2_fs.h b/include/linux/nilfs2_fs.h
index e9fcf90..0d7f814 100644
--- a/include/linux/nilfs2_fs.h
+++ b/include/linux/nilfs2_fs.h
@@ -13,10 +13,6 @@
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU Lesser General Public License for more details.
  *
- * You should have received a copy of the GNU Lesser General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
- *
  * Written by Koji Sato <koji@osrg.net>
  *            Ryusuke Konishi <ryusuke@osrg.net>
  */
-- 
1.8.3.1

