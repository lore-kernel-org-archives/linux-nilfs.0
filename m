From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: NILFS utils 2.0.13 released
Date: Mon, 22 Jun 2009 16:05:57 +0900 (JST)
Message-ID: <20090622.160557.55245140.ryusuke@osrg.net>
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

Hi everyone,

We have released nilfs-utils-2.0.13.

This release fixed the reported cleanerd failure on mount time, and
enhanced rmcp command so that it can handle range of checkpoint
numbers.

The range can be specified as follows:

 # rmcp 10..1000  # remove checkpoints [10, 1000]
 # rmcp ..1000    # [-,1000]
 # rmcp 10..      # [10,-]

The other changes include:

 * fix the problem that lssu didn't display segments properly when the
   number of segments was specified with -n option.
 * prompt user to use chcp when rmcp is tried against snapshots.
 * add fallback mode to cleanerd which does retries in case of memory
   shortage including kernel vmap errors.
 * add retry_interval directive to nilfs_cleanerd.conf which specifies
   the retry interval in the fallback mode.
 * update manpages about nilfs_cleanerd, nilfs_cleanerd.conf, and rmcp.

The updated package is available at
http://www.nilfs.org/en/download.html

Thanks,
Ryusuke Konishi
