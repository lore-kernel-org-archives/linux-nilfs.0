From: Reinoud Zandijk <reinoud-S783fYmB3Ccdnm+yROfE0A@public.gmane.org>
Subject: Re: nilfs2 fails to mount after io/error
Date: Thu, 27 Nov 2008 18:10:06 +0100
Message-ID: <20081127171006.GA3654@aardappel.13thmonkey.org>
References: <20081126182158.20FD28306@blinkenlights.ch>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20081126182158.20FD28306-4ZM2p5qjiQGewZBzVTKGGg@public.gmane.org>
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

Hi,

On Wed, Nov 26, 2008 at 07:22:12PM +0100, Adrian Ulrich wrote:
> I just had an usb-harddrive (with nilfs2 and ext3 mounted) throw some IO-Errors (Most likely due to a crappy usb controller)
> and now nilfs2 refuses to mount the partition:
> 
> NILFS warning: Sequence number mismatch
> NILFS: error searching super root.
> 
> (ext3 still works fine)

Well you could try to mount on an older snapshot or create a snapshot 
first?? i dont have a running nilfs2 around here so i can't try out the 
advise :)

With regards,
Reinoud
