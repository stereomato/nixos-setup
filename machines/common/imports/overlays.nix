{ lib, pkgs, ... }:{
  
	nixpkgs.overlays = [(
		self: super: {
			threadsFile = pkgs.runCommandLocal "cores-for-hardware-config" {} '' 
				mkdir $out
				nproc | tr -d '\n' | tee $out/numThreads
				echo '''$(($(nproc) / 2 ))| tr -d '\n' | tee $out/halfNumThreads
			'';
			nvtop = super.nvtop.override {
				nvidia = false;
			};
			
			#qadwaitadecorations = super.qadwaitadecorations.override {
				# qt5ShadowsSupport = true;
			#};
			jdk17 = super.jdk17.override {
				enableJavaFX = true;
			};

			
		}
	)];
}
