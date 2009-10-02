From: Fernando =?utf-8?Q?Jim=C3=A9nez?= Solano <fernandojs-KQycZriHgL4/CV0X4SHnnw@public.gmane.org>
Subject: Re: NILFS space usage
Date: Fri, 2 Oct 2009 18:59:07 +0200
Message-ID: <20091002165907.GA3539@discordia.eris>
References: <4ABE0AD7.7000904@att.net>
	<debc30fc0909260627n12616bddif87b25f0ae64b6f5@mail.gmail.com>
	<4ABE13D3.2080809@att.net>
	<debc30fc0909260715u562bd4b0g747327c3e1a0fe37@mail.gmail.com>
	<4ABE2704.6030607@att.net>
	<debc30fc0909260815s412ee145xa90e02d9ce4c942f@mail.gmail.com>
	<4ABE2E86.5010708@att.net>
	<C83C8B9E-C7E0-46B8-913E-6F0C407DE2E9@me.com>
	<80225669DEC80D488C4A0B5150466E1802F17EC3@dekomplm002.net.plm.eds.com>
	<80225669DEC80D488C4A0B5150466E1802F18005@dekomplm002.net.plm.eds.com>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <80225669DEC80D488C4A0B5150466E1802F18005-q6sIb7dcTNEDs3eufgyKiYGWD8NUZu9dQQ4Iyu8u01E@public.gmane.org>
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

On Fri, Oct 02, 2009 at 06:20:41PM +0200, Barham, David wrote:
> I just used the default options on the mkfs and haven't changed any
> setting (other than debug) in nilfs_cleanerd.conf.

There's a parameter on nilfs_cleanerd.conf called protection_period.
It means checkpoints are kept intact at least that many seconds. You
may want to lower that. In addition, you can lower cleaning_interval
to make nilfs_cleanerd act more often, and raise nsegments_per_clean
to perform a more aggressive (and in my experience, CPU intensive)
cleaning.

Unless I'm doing insanely heavy writes or I have very little space
left, I find the defaults to work just fine, but yes, some kind of
autotuning feature in nilfs_cleanerd would be great.
