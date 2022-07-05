			.macro RRC_(i)
			.loop i
			RRC
			.endloop
			.endmacro

			.macro PUSH_B(i)
			.loop i
			PUSH B
			.endloop
			.endmacro

            .macro INR_D(i)
			.loop i
			INR D
			.endloop
			.endmacro