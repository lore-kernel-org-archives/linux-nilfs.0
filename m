From: James Erickson <psykojime-PkbjNfxxIARBDgjK7y7TUQ@public.gmane.org>
Subject: nilfs_cleanerd on root partition
Date: Sat, 20 Jun 2009 16:19:39 -0500
Message-ID: <20090620211939.GA5937@odysseus.gateway.2wire.net>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Content-Disposition: inline
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

i am new to nilfs2 so i am sorry to ask such a simple question. how do i
get nilfs_cleanerd to run on my root partition? my disk is a 64 GB intel
ssd and it is completely full of checkpoints. my system is originally 4
GB in size. it is gentoo amd64 running linux-2.6.30-gentoo-r1. it has
nilfs2 support compiled in the kernel, not as a module. i thought that
nilfs_cleanerd would run when the root patition is mounted but i guess i
was wrong. i will gladly post any requested data. thank you for any help
you can offer in this matter.
