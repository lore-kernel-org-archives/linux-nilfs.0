From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: Re: New utilities release ?
Date: Tue, 29 Dec 2009 04:17:53 +0900 (JST)
Message-ID: <20091229.041753.120336147.ryusuke@osrg.net>
References: <200912281748.19680.yann.morin.1998@anciens.enib.fr>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <200912281748.19680.yann.morin.1998-i2lMhxPFobAPxyCoDXghUg@public.gmane.org>
List-Id: <linux-nilfs.vger.kernel.org>
List-Unsubscribe: <https://www.nilfs.org/mailman/options/users>,
	<mailto:users-request-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org?subject=unsubscribe>
List-Archive: <https://www.nilfs.org/pipermail/users>
List-Post: <mailto:users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
List-Help: <mailto:users-request-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org?subject=help>
List-Subscribe: <https://www.nilfs.org/mailman/listinfo/users>,
	<mailto:users-request-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org?subject=subscribe>
Sender: users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
Errors-To: users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
To: yann.morin.1998-i2lMhxPFobAPxyCoDXghUg@public.gmane.org
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org

On Mon, 28 Dec 2009 17:48:19 +0100, "Yann E. MORIN" wrote:
> Hello All!
> 
> I was wondering when the next nilfs2-utils release was scheduled for.
> Looking at the git tree, there are only three /minor/ changesets since
> 2.0.14 was released, meaning that probably the utilities are now quite
> mature.

Well, I think we have much work to do for utils especially for
cleanerd.  Unfortunately, I had my hands full with the kernel code for
the past several months.

> Maybe it would be time to tag 2.0.15 (or 2.1.0). That would be nicve to
> have a release which does not need patching (even those three /trivial/
> patches).

All right, it should be once refreshed.  I also have a pending change
from David Smid which allows users to specify protection period
through "pp" mount option.  I'll take a moment for these.

> Regards,
> Yann E. MORIN.

Cheers,
Ryusuke Konishi
