From: Reinoud Zandijk <reinoud-S783fYmB3Ccdnm+yROfE0A@public.gmane.org>
Subject: Re: nilfs2 fails to mount after io/error
Date: Sat, 6 Dec 2008 20:53:08 +0100
Message-ID: <20081206195308.GA11115@aardappel.13thmonkey.org>
References: <20081204092947.c29d230d.adrian@blinkenlights.ch>
	<20081204.215805.88483726.ryusuke@osrg.net>
	<20081204140431.ec72f1ec.adrian@blinkenlights.ch>
	<20081207.040509.20004012.ryusuke@osrg.net>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20081207.040509.20004012.ryusuke-sG5X7nlA6pw@public.gmane.org>
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

Hi folks, hi Ryusuke,

On Sun, Dec 07, 2008 at 04:05:09AM +0900, Ryusuke Konishi wrote:
> On Thu, 4 Dec 2008 14:04:31 +0100, Adrian Ulrich wrote:
> Sorry to keep you waiting. ;-)
> 
> I will attach a patch against nilfs2-utils-2.0.6, which adds the
> tool 'fsck0.nilfs2'.
> 
>  # fsck0.nilfs2 <device name>
> 
> will, hopefully, correct your partition.
> (I'm not sure because it's not yet tested enough)

looks nice Ryusuke. Could the problem be averted though by *only* writing the
superblock on dismount or when the origional block would be overwritten.
Seperated by a disc flush of course :)

With regards,
Reinoud
