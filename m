From: Adrian Ulrich <nilfs-4ZM2p5qjiQGewZBzVTKGGg@public.gmane.org>
Subject: Nilfs 2.0.1 fails to mount a nilfs-2.0.0 filesystem
Date: Mon, 24 Mar 2008 12:54:04 +0100
Message-ID: <20080324125404.f299fbe2.nilfs@blinkenlights.ch>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
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
Content-Type: text/plain; charset="us-ascii"
To: users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org

Hi,

I've just upgraded from nilfs 2.0.0 to 2.0.1 (kernel + userland) and noticed
that nilfs 2.0.1 fails to mount my 2.0.0 filesystem:

> NILFS: Invalid checkpoint (checkpoint number=12178)
> NILFS: error loading a checkpoint (checkpoint number=12178).

Mounting the filesystem with nilfs-2.0.0 works just fine.

Is this a bug or did the disk-format change in 2.0.1 ?


Regards, 
 Adrian
