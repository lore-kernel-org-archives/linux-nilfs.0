From: Adrian Ulrich <adrian-4ZM2p5qjiQGewZBzVTKGGg@public.gmane.org>
Subject: nilfs2 fails to mount after io/error
Date: Wed, 26 Nov 2008 19:22:12 +0100
Message-ID: <20081126182158.20FD28306@blinkenlights.ch>
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

Hi,

I just had an usb-harddrive (with nilfs2 and ext3 mounted) throw some IO-Errors (Most likely due to a crappy usb controller)
and now nilfs2 refuses to mount the partition:

NILFS warning: Sequence number mismatch
NILFS: error searching super root.

(ext3 still works fine)

Any idea?

Regards,
 Adrian





-- 
 RFC 1925:
   (11) Every old idea will be proposed again with a different name and
        a different presentation, regardless of whether it works.
