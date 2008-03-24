From: Adrian Ulrich <adrian-4ZM2p5qjiQGewZBzVTKGGg@public.gmane.org>
Subject: Nilfs 2.0.1 fails to mount a nilfs-2.0.0 filesystem
Date: Mon, 24 Mar 2008 12:48:05 +0100
Message-ID: <20080324114806.60D0321405F@blinkenlights.ch>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=blinkenlights.ch;
	s=sockentier; t=1206359286; bh=l+0DxR19jRx+7LtCR+pnTTJDqyL19X/i7Io/
	McBfs3k=; h=Date:From:To:Subject:X-Mailer:X-Face:Mime-Version:
	Content-Type:Content-Transfer-Encoding:Message-Id; b=t9oTCEZG1hCcL
	7YfY6L+9282SCcIRnDcBVEKaE/ISE2t6qTP9O5yvtgaGF2MWvWY0Y7mqa+BkNrZbVUU
	1lckviP1bWgEk8Mwt8NRnKacS5q2qAXZ0/yMss3FF2w7nqyRjis3w6ajtRzYk7nBM8m
	O2rauN+4ZcYpooMtPBK8L+XY=
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

-- 
 RFC 1925:
   (11) Every old idea will be proposed again with a different name and
        a different presentation, regardless of whether it works.
