From: Reinoud Zandijk <reinoud-S783fYmB3Ccdnm+yROfE0A@public.gmane.org>
Subject: Re: IOzone testing
Date: Sat, 26 Sep 2009 20:06:13 +0200
Message-ID: <20090926180613.GA6733@aardappel.13thmonkey.org>
References: <4ABE0553.3090502@att.net>
	<debc30fc0909260554s21969638h280d9e6f89b7596e@mail.gmail.com>
	<4ABE0AD7.7000904@att.net>
	<debc30fc0909260627n12616bddif87b25f0ae64b6f5@mail.gmail.com>
	<4ABE13D3.2080809@att.net>
	<debc30fc0909260715u562bd4b0g747327c3e1a0fe37@mail.gmail.com>
	<4ABE2704.6030607@att.net>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <4ABE2704.6030607-fOdFMYwuEsI@public.gmane.org>
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

Hi folks,

On Sat, Sep 26, 2009 at 10:36:52AM -0400, Jeff Layton wrote:
> So, let me summarize what I think I should do to test nilfs with
> IOzone without the impact of the checkpoints and without filling
> up the space.

I've dug into the iozone code and found it littered with sync(2) calls to
flush the buffers. This is what creates the checkpoints. If you take a big
enough disc it wouldn't matter otherwise you'll get into dynamic behaviour
IOzone is not really build for.

With regards,
Reinoud
